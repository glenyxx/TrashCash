import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/onboarding_welcome_screen.dart';
import '../screens/auth/onboarding_rewards_screen.dart';
import '../screens/auth/onboarding_impact_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/scan/qr_scanner_screen.dart';
import '../screens/scan/upload_proof_screen.dart';
import '../screens/pickup/schedule_pickup_screen.dart';
import '../screens/report/create_report_screen.dart';
import '../screens/report/map_view_screen.dart';
import '../screens/wallet/wallet_screen.dart';
import '../screens/wallet/rewards_screen.dart';

class AppRoutes {
  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String onboardingWelcome = '/onboarding-welcome';
  static const String onboardingRewards = '/onboarding-rewards';
  static const String onboardingImpact = '/onboarding-impact';

  // Main App Routes
  static const String home = '/home';
  static const String scan = '/scan';
  static const String uploadProof = '/upload-proof';
  static const String schedulePickup = '/schedule-pickup';
  static const String createReport = '/create-report';
  static const String mapView = '/map-view';
  static const String wallet = '/wallet';
  static const String rewards = '/rewards';

  // Route Map
  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    onboardingWelcome: (context) => const OnboardingWelcomeScreen(),
    onboardingRewards: (context) => const OnboardingRewardsScreen(),
    onboardingImpact: (context) => const OnboardingImpactScreen(),
    home: (context) => const HomeScreen(),
    scan: (context) => const QRScannerScreen(),
    uploadProof: (context) => const UploadProofScreen(),
    schedulePickup: (context) => const SchedulePickupScreen(),
    createReport: (context) => const CreateReportScreen(),
    mapView: (context) => const MapViewScreen(),
    wallet: (context) => const WalletScreen(),
    rewards: (context) => const RewardsScreen(),
  };

  // Initial Route
  static const String initialRoute = login;
}