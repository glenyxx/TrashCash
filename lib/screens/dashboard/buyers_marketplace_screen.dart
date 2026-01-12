import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../config/theme.dart';

class BuyersMarketplaceScreen extends StatefulWidget {
  const BuyersMarketplaceScreen({super.key});

  @override
  State<BuyersMarketplaceScreen> createState() => _BuyersMarketplaceScreenState();
}

class _BuyersMarketplaceScreenState extends State<BuyersMarketplaceScreen> {
  String _selectedCategory = 'All';

  final categories = ['All', 'Plastic', 'Aluminum', 'E-Waste', 'Organic', 'Glass', 'Paper'];

  final products = [
    {
      'id': 1,
      'name': 'PET Plastic Bottles',
      'category': 'Plastic',
      'price': '200',
      'unit': 'per kg',
      'available': '2,500 kg',
      'location': 'Douala Central',
      'quality': 'Premium',
      'supplier': 'TrashCash Facility A',
      'image': 'https://images.unsplash.com/photo-1621451537084-482c73073a0f?w=400',
      'rating': '4.8',
    },
    {
      'id': 2,
      'name': 'Aluminum Cans',
      'category': 'Aluminum',
      'price': '450',
      'unit': 'per kg',
      'available': '1,200 kg',
      'location': 'Yaoundé Center',
      'quality': 'Standard',
      'supplier': 'TrashCash Facility B',
      'image': 'https://images.unsplash.com/photo-1594122230689-45899d9e6f69?w=400',
      'rating': '4.9',
    },
    {
      'id': 3,
      'name': 'E-Waste Components',
      'category': 'E-Waste',
      'price': '850',
      'unit': 'per kg',
      'available': '450 kg',
      'location': 'Douala Industrial',
      'quality': 'Premium',
      'supplier': 'TrashCash Facility C',
      'image': 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=400',
      'rating': '4.7',
    },
    {
      'id': 4,
      'name': 'Mixed Paper',
      'category': 'Paper',
      'price': '120',
      'unit': 'per kg',
      'available': '3,800 kg',
      'location': 'Yaoundé West',
      'quality': 'Standard',
      'supplier': 'TrashCash Facility D',
      'image': 'https://images.unsplash.com/photo-1604943911564-f4ce4c5f3487?w=400',
      'rating': '4.6',
    },
    {
      'id': 5,
      'name': 'Glass Bottles',
      'category': 'Glass',
      'price': '180',
      'unit': 'per kg',
      'available': '900 kg',
      'location': 'Douala Port',
      'quality': 'Premium',
      'supplier': 'TrashCash Facility E',
      'image': 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400',
      'rating': '4.8',
    },
    {
      'id': 6,
      'name': 'Organic Compost',
      'category': 'Organic',
      'price': '90',
      'unit': 'per kg',
      'available': '5,000 kg',
      'location': 'Yaoundé Rural',
      'quality': 'Standard',
      'supplier': 'TrashCash Facility F',
      'image': 'https://images.unsplash.com/photo-1611095790444-1dfa35e37b52?w=400',
      'rating': '4.5',
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    if (_selectedCategory == 'All') return products;
    return products.where((p) => p['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildAppBar()),
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildCategoryTabs()),
            SliverToBoxAdapter(child: _buildStatsCards()),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: MediaQuery.of(context).size.width > 600 ? 0.75 : 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildProductCard(filteredProducts[index]),
                  childCount: filteredProducts.length,
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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.recycling, color: AppTheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text('TrashCash Marketplace', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=22'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return FadeIn(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Browse Materials',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Purchase high-quality recycled materials from verified suppliers',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.all(16),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search materials...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () {},
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
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
              child: ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
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

  Widget _buildStatsCards() {
    return FadeInUp(
      delay: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard('8.2T', 'Available', Icons.inventory_2, Colors.blue.shade600),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('24', 'Suppliers', Icons.business, Colors.purple.shade600),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('156', 'Orders', Icons.shopping_bag, Colors.green.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final isPremium = product['quality'] == 'Premium';

    return FadeInUp(
      delay: Duration(milliseconds: 800 + (product['id'] as int) * 100),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    product['image'] as String,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 48),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPremium ? Colors.amber.shade700 : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPremium ? Icons.star : Icons.verified,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product['quality'] as String,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product['location'] as String,
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.inventory, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          product['available'] as String,
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product['price']} XAF',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primary,
                              ),
                            ),
                            Text(
                              product['unit'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: AppTheme.primary,
                            size: 20,
                          ),
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
    );
  }
}