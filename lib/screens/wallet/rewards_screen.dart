import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../config/theme.dart';

class RewardsStoreScreen extends StatefulWidget {
  const RewardsStoreScreen({super.key});

  @override
  State<RewardsStoreScreen> createState() => _RewardsStoreScreenState();
}

class _RewardsStoreScreenState extends State<RewardsStoreScreen> {
  String _selectedCategory = 'All';
  final int userPoints = 2450;

  final categories = ['All', 'Airtime', 'Shopping', 'Services', 'Donations'];

  final rewards = [
    {
      'id': 1,
      'name': 'MTN Airtime 1000 XAF',
      'category': 'Airtime',
      'points': 200,
      'value': '1,000 XAF',
      'description': 'Mobile airtime credit',
      'icon': Icons.phone_android,
      'color': Colors.yellow.shade700,
      'popular': true,
    },
    {
      'id': 2,
      'name': 'Orange Airtime 2000 XAF',
      'category': 'Airtime',
      'points': 380,
      'value': '2,000 XAF',
      'description': 'Mobile airtime credit',
      'icon': Icons.phone_android,
      'color': Colors.orange.shade700,
      'popular': false,
    },
    {
      'id': 3,
      'name': 'Casino Supermarket Voucher',
      'category': 'Shopping',
      'points': 500,
      'value': '2,500 XAF',
      'description': 'Shopping voucher',
      'icon': Icons.shopping_bag,
      'color': Colors.blue.shade700,
      'popular': true,
    },
    {
      'id': 4,
      'name': 'Dovv Ride Credit',
      'category': 'Services',
      'points': 300,
      'value': '1,500 XAF',
      'description': 'Ride-hailing credit',
      'icon': Icons.local_taxi,
      'color': Colors.purple.shade700,
      'popular': false,
    },
    {
      'id': 5,
      'name': 'Plant a Tree',
      'category': 'Donations',
      'points': 150,
      'value': '1 Tree',
      'description': 'Environmental contribution',
      'icon': Icons.eco,
      'color': Colors.green.shade700,
      'popular': true,
    },
    {
      'id': 6,
      'name': 'Jumia Shopping Voucher',
      'category': 'Shopping',
      'points': 600,
      'value': '3,000 XAF',
      'description': 'Online shopping credit',
      'icon': Icons.shopping_cart,
      'color': Colors.red.shade700,
      'popular': false,
    },
    {
      'id': 7,
      'name': 'Netflix 1 Month',
      'category': 'Services',
      'points': 800,
      'value': '4,000 XAF',
      'description': 'Streaming subscription',
      'icon': Icons.play_circle,
      'color': Colors.red.shade900,
      'popular': true,
    },
    {
      'id': 8,
      'name': 'Clean Water Donation',
      'category': 'Donations',
      'points': 250,
      'value': '50L Water',
      'description': 'Community support',
      'icon': Icons.water_drop,
      'color': Colors.blue.shade500,
      'popular': false,
    },
  ];

  List<Map<String, dynamic>> get filteredRewards {
    if (_selectedCategory == 'All') return rewards;
    return rewards.where((r) => r['category'] == _selectedCategory).toList();
  }

  void _redeemReward(Map<String, dynamic> reward) {
    final points = reward['points'] as int;

    if (userPoints < points) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Insufficient points! You need ${points - userPoints} more points.'),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildRedeemSheet(reward),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildAppBar()),
            SliverToBoxAdapter(child: _buildPointsCard()),
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildCategoryTabs()),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: MediaQuery.of(context).size.width > 600 ? 0.85 : 1.1,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildRewardCard(filteredRewards[index]),
                  childCount: filteredRewards.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Text('Rewards Store', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    return FadeIn(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primary,
              AppTheme.primary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.stars,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Points',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userPoints.toString(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '≈ ${(userPoints * 5).toLocaleString()} XAF',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '1 pt = 5 XAF',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Redeem Your Points',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose from airtime, shopping vouchers, or donate to good causes',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return FadeIn(
      delay: const Duration(milliseconds: 400),
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedCategory = category);
                },
                backgroundColor: Colors.white,
                selectedColor: AppTheme.primary.withOpacity(0.2),
                checkmarkColor: AppTheme.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.primary : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                side: BorderSide(
                  color: isSelected ? AppTheme.primary : const Color(0xFFE5E7EB),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRewardCard(Map<String, dynamic> reward) {
    final points = reward['points'] as int;
    final canAfford = userPoints >= points;
    final isPopular = reward['popular'] as bool;

    return FadeInUp(
      delay: Duration(milliseconds: 600 + (reward['id'] as int) * 100),
      child: GestureDetector(
        onTap: () => _redeemReward(reward),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPopular ? AppTheme.primary.withOpacity(0.3) : const Color(0xFFE5E7EB),
              width: isPopular ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isPopular)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'POPULAR',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (reward['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          reward['icon'] as IconData,
                          color: reward['color'] as Color,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        reward['name'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        reward['description'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.stars,
                                    color: canAfford ? AppTheme.primary : Colors.grey[400],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$points pts',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: canAfford ? AppTheme.primary : Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                reward['value'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            canAfford ? Icons.arrow_forward : Icons.lock,
                            color: canAfford ? AppTheme.primary : Colors.grey[400],
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRedeemSheet(Map<String, dynamic> reward) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (reward['color'] as Color).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              reward['icon'] as IconData,
              color: reward['color'] as Color,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            reward['name'] as String,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Redeem for ${reward['points']} points',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Balance After:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${userPoints - (reward['points'] as int)} pts',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 12),
                        Text('${reward['name']} redeemed successfully!'),
                      ],
                    ),
                    backgroundColor: Colors.green.shade600,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirm Redemption',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

extension on int {
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }
}