import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';

class SchedulePickupScreen extends StatefulWidget {
  const SchedulePickupScreen({super.key});

  @override
  State<SchedulePickupScreen> createState() => _SchedulePickupScreenState();
}

class _SchedulePickupScreenState extends State<SchedulePickupScreen> {
  String? selectedWasteType;
  DateTime? selectedDate;
  String? selectedTimeSlot;
  double volumeValue = 2.0;
  final locationController = TextEditingController();
  final instructionsController = TextEditingController();

  final wasteTypes = [
    {'id': 'plastic', 'name': 'Plastic', 'subtitle': 'Bottles, containers', 'image': 'https://images.unsplash.com/photo-1621451537084-482c73073a0f?w=400'},
    {'id': 'aluminum', 'name': 'Aluminum Cans', 'subtitle': 'Soda cans, tins', 'image': 'https://images.unsplash.com/photo-1594122230689-45899d9e6f69?w=400'},
    {'id': 'ewaste', 'name': 'E-Waste', 'subtitle': 'Old electronics', 'image': 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=400'},
    {'id': 'organic', 'name': 'Organic', 'subtitle': 'Food scraps', 'image': 'https://images.unsplash.com/photo-1611095790444-1dfa35e37b52?w=400'},
  ];

  final timeSlots = [
    '08:00 - 10:00',
    '10:00 - 12:00',
    '13:00 - 15:00',
    '15:00 - 17:00',
  ];

  @override
  void initState() {
    super.initState();
    selectedWasteType = 'plastic';
    selectedDate = DateTime.now().add(const Duration(days: 2));
    selectedTimeSlot = '10:00 - 12:00';
    locationController.text = 'Mvan, Yaoundé';
    instructionsController.text = 'Behind the pharmacy...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: _buildAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1024;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: isDesktop
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildFormSteps()),
                      const SizedBox(width: 32),
                      SizedBox(width: 380, child: _buildSummary()),
                    ],
                  )
                      : Column(
                    children: [
                      _buildFormSteps(),
                      const SizedBox(height: 24),
                      _buildSummary(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
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
          const Text('TrashCash'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Log Out'),
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildFormSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page Heading
        FadeInLeft(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schedule Your Pickup',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Turn your waste into cash. Tell us what you have and where to find you.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // Step 1: Waste Type
        _buildStep1(),
        const SizedBox(height: 40),

        // Step 2: Location
        _buildStep2(),
        const SizedBox(height: 40),

        // Step 3: Date & Time
        _buildStep3(),
        const SizedBox(height: 40),

        // Step 4: Volume
        _buildStep4(),
      ],
    );
  }

  Widget _buildStep1() {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStepNumber(1, true),
              const SizedBox(width: 12),
              Text(
                'Select Waste Type',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: wasteTypes.length,
            itemBuilder: (context, index) {
              final type = wasteTypes[index];
              final isSelected = selectedWasteType == type['id'];

              return GestureDetector(
                onTap: () => setState(() => selectedWasteType = type['id'] as String),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? AppTheme.primary.withOpacity(0.1) : Colors.white,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: Image.network(
                                type['image'] as String,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                colorBlendMode: isSelected ? null : BlendMode.saturation,
                                color: isSelected ? null : Colors.grey,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image, size: 40),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type['name'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  type['subtitle'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isSelected)
                        const Positioned(
                          top: 12,
                          right: 12,
                          child: Icon(
                            Icons.check_circle,
                            color: AppTheme.primary,
                            size: 24,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStepNumber(2, false),
              const SizedBox(width: 12),
              Text(
                'Pickup Location',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;

                return isMobile
                    ? Column(
                  children: [
                    _buildLocationInputs(),
                    const SizedBox(height: 24),
                    _buildMapPreview(),
                  ],
                )
                    : Row(
                  children: [
                    Expanded(child: _buildLocationInputs()),
                    const SizedBox(width: 24),
                    Expanded(child: _buildMapPreview()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Address',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: locationController,
          decoration: InputDecoration(
            hintText: 'Enter your street or neighborhood',
            prefixIcon: const Icon(Icons.search, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Specific Instructions',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: instructionsController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'e.g. Behind the pharmacy, blue gate. Call upon arrival.',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.my_location, color: AppTheme.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'Use my current location',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=600',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.map, size: 60),
              ),
            ),
            Container(color: Colors.black.withOpacity(0.1)),
            const Center(
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return FadeInUp(
      delay: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStepNumber(3, false),
              const SizedBox(width: 12),
              Text(
                'When is best for you?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;

                return isMobile
                    ? Column(
                  children: [
                    _buildCalendar(),
                    const Divider(height: 48),
                    _buildTimeSlots(),
                  ],
                )
                    : Row(
                  children: [
                    Expanded(child: _buildCalendar()),
                    Container(
                      width: 1,
                      height: 300,
                      color: const Color(0xFFE5E7EB),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    Expanded(child: _buildTimeSlots()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(selectedDate ?? DateTime.now()),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Simplified calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: 35,
          itemBuilder: (context, index) {
            final day = index - 5;
            final isSelected = day == 10;

            return Container(
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : null,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                day > 0 ? '$day' : '',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? Colors.black : null,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Slots',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: timeSlots.map((slot) {
            final isSelected = selectedTimeSlot == slot;
            return InkWell(
              onTap: () => setState(() => selectedTimeSlot = slot),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : null,
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : const Color(0xFFD1D5DB),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  slot,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.black : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return FadeInUp(
      delay: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStepNumber(4, false),
              const SizedBox(width: 12),
              Text(
                'Estimated Volume',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOU HAVE APPROX.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${volumeValue.toInt()} - ${(volumeValue + 1).toInt()} Bags',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.grey[300]),
                  ],
                ),
                const SizedBox(height: 32),
                Slider(
                  value: volumeValue,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: AppTheme.primary,
                  onChanged: (value) => setState(() => volumeValue = value),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Small Bag', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    Text('Full Truck', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return FadeInRight(
      delay: const Duration(milliseconds: 1000),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long, color: AppTheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Pickup Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSummaryItem(Icons.delete_outline, 'Waste Type', 'Plastic (Bottles)'),
                const SizedBox(height: 20),
                _buildSummaryItem(Icons.location_on_outlined, 'Location', locationController.text),
                const SizedBox(height: 20),
                _buildSummaryItem(
                  Icons.schedule,
                  'Date & Time',
                  'Oct 10, ${selectedTimeSlot ?? '10:00-12:00'}',
                ),
                const Divider(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated Earnings',
                            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '50 TC Points',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.stars, color: AppTheme.primary, size: 24),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pickup scheduled successfully!')),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm Pickup', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'By confirming, you agree to our Terms of Service',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.help_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need help packing?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Check our recycling guide to maximize your earnings.',
                        style: TextStyle(fontSize: 11, color: Colors.blue.shade700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'View Guide →',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.grey[600], size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Edit', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildStepNumber(int number, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primary : Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.black : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    locationController.dispose();
    instructionsController.dispose();
    super.dispose();
  }
}