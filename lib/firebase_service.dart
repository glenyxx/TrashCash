import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  // Singletons
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // ============================================
  // AUTHENTICATION
  // ============================================

  /// Register new user with email and password
  static Future<UserCredential> register(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Login with email and password
  static Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Logout current user
  static Future<void> logout() async {
    await _auth.signOut();
  }

  /// Get current logged-in user
  static User? get currentUser => _auth.currentUser;

  /// Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

  // ============================================
  // USER MANAGEMENT
  // ============================================

  /// Create user profile in Firestore
  static Future<void> createUserProfile({
    required String uid,
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String role, // citizen, collector, buyer
    String city = '',
    String neighborhood = '',
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'role': role,
      'city': city,
      'neighborhood': neighborhood,
      'profileImageUrl': '',
      'ecoPoints': 0,
      'totalEarnings': 0,
      'isVerified': false,
      'isPhoneVerified': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get user profile
  static Future<DocumentSnapshot> getUserProfile(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  /// Update user profile
  static Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('users').doc(uid).update(data);
  }

  /// Get user stats
  static Future<Map<String, dynamic>> getUserStats(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;

    final reportsSnapshot = await _firestore
        .collection('wasteReports')
        .where('userId', isEqualTo: uid)
        .get();

    final pickupsSnapshot = await _firestore
        .collection('pickups')
        .where('citizenId', isEqualTo: uid)
        .where('status', isEqualTo: 'completed')
        .get();

    return {
      'ecoPoints': userData['ecoPoints'] ?? 0,
      'totalEarnings': userData['totalEarnings'] ?? 0,
      'totalReports': reportsSnapshot.docs.length,
      'completedPickups': pickupsSnapshot.docs.length,
    };
  }

  // ============================================
  // WASTE REPORTS
  // ============================================

  /// Create waste report
  static Future<String> createWasteReport({
    required String userId,
    required String wasteType,
    required Map<String, dynamic> location,
    required double estimatedAmount,
    String photoUrl = '',
  }) async {
    final doc = await _firestore.collection('wasteReports').add({
      'userId': userId,
      'wasteType': wasteType,
      'location': location,
      'estimatedAmount': estimatedAmount,
      'photoUrl': photoUrl,
      'status': 'pending',
      'verificationNotes': '',
      'verifiedBy': '',
      'verifiedAt': null,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  /// Get user's waste reports
  static Stream<QuerySnapshot> getWasteReports(String userId) {
    return _firestore
        .collection('wasteReports')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Get all waste reports (for collectors/admins)
  static Stream<QuerySnapshot> getAllWasteReports({String? status}) {
    Query query = _firestore.collection('wasteReports');

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    return query.orderBy('createdAt', descending: true).snapshots();
  }

  /// Update waste report
  static Future<void> updateWasteReport(String reportId, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('wasteReports').doc(reportId).update(data);
  }

  /// Delete waste report
  static Future<void> deleteWasteReport(String reportId) async {
    await _firestore.collection('wasteReports').doc(reportId).delete();
  }

  // ============================================
  // PICKUPS
  // ============================================

  /// Schedule pickup
  static Future<String> schedulePickup({
    required String citizenId,
    required String wasteType,
    required DateTime scheduledDate,
    required Map<String, dynamic> location,
    required double estimatedAmount,
  }) async {
    final doc = await _firestore.collection('pickups').add({
      'citizenId': citizenId,
      'collectorId': '',
      'wasteType': wasteType,
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'location': location,
      'estimatedAmount': estimatedAmount,
      'actualAmount': 0,
      'status': 'scheduled',
      'qrCodeData': '',
      'paymentAmount': 0,
      'paymentStatus': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  /// Get user's pickups
  static Stream<QuerySnapshot> getPickups(String userId, {String? role}) {
    Query query = _firestore.collection('pickups');

    if (role == 'citizen') {
      query = query.where('citizenId', isEqualTo: userId);
    } else if (role == 'collector') {
      query = query.where('collectorId', isEqualTo: userId);
    }

    return query.orderBy('scheduledDate', descending: true).snapshots();
  }

  /// Update pickup
  static Future<void> updatePickup(String pickupId, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('pickups').doc(pickupId).update(data);
  }

  /// Complete pickup (award points)
  static Future<void> completePickup({
    required String pickupId,
    required String citizenId,
    required double actualAmount,
  }) async {
    final pointsPerKg = 10;
    final xafPerKg = 100;

    final pointsAwarded = (actualAmount * pointsPerKg).toInt();
    final paymentAmount = actualAmount * xafPerKg;

    // Update pickup
    await _firestore.collection('pickups').doc(pickupId).update({
      'status': 'completed',
      'actualAmount': actualAmount,
      'paymentAmount': paymentAmount,
      'paymentStatus': 'completed',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Update user points and earnings
    final userDoc = await _firestore.collection('users').doc(citizenId).get();
    final userData = userDoc.data() as Map<String, dynamic>;

    await _firestore.collection('users').doc(citizenId).update({
      'ecoPoints': (userData['ecoPoints'] ?? 0) + pointsAwarded,
      'totalEarnings': (userData['totalEarnings'] ?? 0) + paymentAmount,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Create transaction
    await _firestore.collection('transactions').add({
      'userId': citizenId,
      'pickupId': pickupId,
      'type': 'earning',
      'amount': paymentAmount,
      'pointsAwarded': pointsAwarded,
      'status': 'completed',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ============================================
  // REWARDS
  // ============================================

  /// Get all active rewards
  static Stream<QuerySnapshot> getRewards() {
    return _firestore
        .collection('rewards')
        .where('isActive', isEqualTo: true)
        .orderBy('pointsRequired')
        .snapshots();
  }

  /// Redeem reward
  static Future<String> redeemReward({
    required String userId,
    required String rewardId,
    required int pointsRequired,
  }) async {
    // Get user points
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    final currentPoints = userData['ecoPoints'] ?? 0;

    if (currentPoints < pointsRequired) {
      throw Exception('Insufficient points');
    }

    // Create redemption
    final redemptionDoc = await _firestore.collection('rewardRedemptions').add({
      'userId': userId,
      'rewardId': rewardId,
      'pointsSpent': pointsRequired,
      'status': 'pending',
      'fulfillmentCode': 'REWARD-${DateTime.now().millisecondsSinceEpoch}',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Deduct points
    await _firestore.collection('users').doc(userId).update({
      'ecoPoints': currentPoints - pointsRequired,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return redemptionDoc.id;
  }

  /// Get user's redemptions
  static Stream<QuerySnapshot> getRedemptions(String userId) {
    return _firestore
        .collection('rewardRedemptions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ============================================
  // MARKETPLACE
  // ============================================

  /// Get marketplace products
  static Stream<QuerySnapshot> getMarketplaceProducts() {
    return _firestore
        .collection('marketplaceProducts')
        .where('isVerified', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Create marketplace product
  static Future<String> createMarketplaceProduct({
    required String sellerId,
    required String name,
    required String materialType,
    required double pricePerKg,
    required double availableQuantity,
    required String location,
    required String qualityGrade,
  }) async {
    final doc = await _firestore.collection('marketplaceProducts').add({
      'sellerId': sellerId,
      'name': name,
      'materialType': materialType,
      'pricePerKg': pricePerKg,
      'availableQuantity': availableQuantity,
      'location': location,
      'qualityGrade': qualityGrade,
      'rating': 0,
      'isVerified': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  // ============================================
  // STORAGE (Images)
  // ============================================

  /// Upload image to Firebase Storage
  static Future<String> uploadImage(String path, Uint8List imageData) async {
    final ref = _storage.ref().child(path);
    final uploadTask = await ref.putData(imageData);
    return await uploadTask.ref.getDownloadURL();
  }

  /// Upload waste report photo
  static Future<String> uploadWastePhoto(String userId, Uint8List imageData) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = 'waste-reports/$userId/$timestamp.jpg';
    return await uploadImage(path, imageData);
  }

  /// Upload profile picture
  static Future<String> uploadProfilePicture(String userId, Uint8List imageData) async {
    final path = 'profile-pictures/$userId.jpg';
    return await uploadImage(path, imageData);
  }

  // ============================================
  // TRANSACTIONS
  // ============================================

  /// Get user transactions
  static Stream<QuerySnapshot> getTransactions(String userId) {
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ============================================
  // DROP-OFF LOCATIONS
  // ============================================

  /// Get all drop-off locations
  static Stream<QuerySnapshot> getDropoffLocations() {
    return _firestore
        .collection('dropoffLocations')
        .where('isVerified', isEqualTo: true)
        .snapshots();
  }
}