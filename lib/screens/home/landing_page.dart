import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 10 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 80), // Space for fixed navbar
                _buildHeroSection(context),
                _buildStatsSection(context),
                _buildHowItWorksSection(context),
                _buildTestimonialsSection(context),
                _buildCTASection(context),
                _buildFooter(context),
              ],
            ),
          ),

          // Fixed Navbar
          _buildNavbar(context),
        ],
      ),
    );
  }

  Widget _buildNavbar(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(_isScrolled ? 0.95 : 0.95),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFF0F4F0).withOpacity(_isScrolled ? 1 : 0.5),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 768;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  FadeIn(
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.recycling,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'TrashCash',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),

                  if (isDesktop) ...[
                    // Desktop Menu
                    Row(
                      children: [
                        _navLink('Home'),
                        const SizedBox(width: 24),
                        _navLink('Marketplace'),
                        const SizedBox(width: 24),
                        _navLink('Education'),
                        const SizedBox(width: 24),
                        _navLink('Contact'),
                        const SizedBox(width: 24),
                        OutlinedButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          child: const Text('Login'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            shadowColor: AppTheme.primary.withOpacity(0.3),
                          ),
                          child: const Text('Join the Movement'),
                        ),
                      ],
                    ),
                  ] else
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => _showMobileMenu(context),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _navLink(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF111811),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(text),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1280),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 768;

          return isDesktop
              ? Row(
            children: [
              Expanded(child: _buildHeroContent(context)),
              const SizedBox(width: 40),
              Expanded(child: _buildHeroImage()),
            ],
          )
              : Column(
            children: [
              _buildHeroImage(),
              const SizedBox(height: 40),
              _buildHeroContent(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeroContent(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'LIVE IN DOUALA & YAOUNDÉ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Headline
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 48,
                height: 1.1,
              ),
              children: const [
                TextSpan(text: 'Turn Your '),
                TextSpan(
                  text: 'Trash',
                  style: TextStyle(color: AppTheme.primary),
                ),
                TextSpan(text: ' into '),
                TextSpan(
                  text: 'Cash',
                  style: TextStyle(color: AppTheme.primary),
                ),
                TextSpan(text: ' in Cameroon'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Subtitle
          Text(
            'Join the digital marketplace connecting urban households with recyclers. Clean your city, earn income, and build a sustainable future.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 18,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),

          // CTA Buttons
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  elevation: 8,
                  shadowColor: AppTheme.primary.withOpacity(0.3),
                ),
                child: const Text(
                  'Start Recycling Today',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/onboarding'),
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('How it works'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Social Proof
          Row(
            children: [
              Stack(
                children: List.generate(3, (index) {
                  return Positioned(
                    left: index * 24.0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.grey[300],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 80),
              Text.rich(
                TextSpan(
                  style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                  children: [
                    const TextSpan(text: 'Trusted by '),
                    TextSpan(
                      text: '5,000+',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ' Cameroonians'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return FadeInRight(
      duration: const Duration(milliseconds: 800),
      child: Stack(
        children: [
          // Glow effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.25),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          // Image
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(color: AppTheme.primary),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.recycling, size: 80, color: AppTheme.primary),
                      ),
                    ),

                    // Stats Badge
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.eco,
                                    color: AppTheme.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '50kg CO₂',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                    Text(
                                      'saved this month',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1280),
      padding: const EdgeInsets.all(16),
      child: FadeInUp(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primary.withOpacity(0.05),
                AppTheme.primary.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 768;

              return Wrap(
                spacing: 40,
                runSpacing: 32,
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  _buildStatItem('250+ Tons', 'Recycled Monthly', Icons.recycling),
                  _buildStatItem('5,000+', 'Active Users', Icons.people),
                  _buildStatItem('50+', 'Collection Points', Icons.location_on),
                  _buildStatItem('15M XAF', 'Earned by Citizens', Icons.payments),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primary, size: 40),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111811),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorksSection(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1280),
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          FadeInUp(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'HOW IT WORKS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Three simple steps to start earning',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Join thousands of Cameroonians turning waste into wealth',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;

              return isDesktop
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildStep(1, 'Collect & Sort', 'Gather recyclable materials from your home or business', Icons.delete_outline)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildStep(2, 'Schedule Pickup', 'Request collection through our app or drop off at a hub', Icons.local_shipping)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildStep(3, 'Get Paid', 'Receive instant credits to your digital wallet', Icons.account_balance_wallet)),
                ],
              )
                  : Column(
                children: [
                  _buildStep(1, 'Collect & Sort', 'Gather recyclable materials from your home or business', Icons.delete_outline),
                  const SizedBox(height: 24),
                  _buildStep(2, 'Schedule Pickup', 'Request collection through our app or drop off at a hub', Icons.local_shipping),
                  const SizedBox(height: 24),
                  _buildStep(3, 'Get Paid', 'Receive instant credits to your digital wallet', Icons.account_balance_wallet),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String title, String description, IconData icon) {
    return FadeInUp(
      delay: Duration(milliseconds: 200 * number),
      child: Container(
        padding: const EdgeInsets.all(24),
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
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(icon, color: AppTheme.primary, size: 28),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$number',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9FAFB),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          children: [
            FadeInUp(
              child: Column(
                children: [
                  Text(
                    'Loved by communities across Cameroon',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),

            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 900;

                return isDesktop
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildTestimonial('Sarah N.', 'Homemaker, Douala', 'I earn an extra 20,000 XAF monthly just from sorting my household waste. It\'s become a family activity!')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTestimonial('Emmanuel K.', 'Student, Yaoundé', 'As a student, every Franc counts. I organize cleanups in my neighborhood every Saturday.')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTestimonial('Mr. Tcham', 'Plant Owner, Douala', 'The consistency of supply has allowed my recycling plant to operate at full capacity.')),
                  ],
                )
                    : Column(
                  children: [
                    _buildTestimonial('Sarah N.', 'Homemaker, Douala', 'I earn an extra 20,000 XAF monthly just from sorting my household waste.'),
                    const SizedBox(height: 24),
                    _buildTestimonial('Emmanuel K.', 'Student, Yaoundé', 'As a student, every Franc counts. I organize cleanups every Saturday.'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonial(String name, String role, String quote) {
    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.format_quote, color: AppTheme.primary.withOpacity(0.4), size: 40),
            const SizedBox(height: 16),
            Text(
              quote,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: Text(name[0], style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(role, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1280),
      margin: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(64),
        decoration: BoxDecoration(
          color: AppTheme.backgroundDark,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Text(
              'Ready to clean up and cash out?',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Join thousands of Cameroonians making a difference today',
              style: TextStyle(fontSize: 18, color: Colors.grey[300]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  ),
                  child: const Text('Join the Movement', style: TextStyle(fontSize: 16)),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  ),
                  child: const Text('Contact Sales', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.recycling, color: AppTheme.primary, size: 24),
                          const SizedBox(width: 8),
                          Text('TrashCash', style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Empowering urban communities to turn waste challenges into economic opportunities.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                _footerColumn('Company', ['About Us', 'Careers', 'Impact Report']),
                const SizedBox(width: 40),
                _footerColumn('Resources', ['Pricing', 'Recycling Guide', 'Support']),
                const SizedBox(width: 40),
                _footerColumn('Legal', ['Privacy', 'Terms', 'Cookies']),
              ],
            ),
            const SizedBox(height: 48),
            Divider(color: Colors.grey[200]),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('© 2024 TrashCash Cameroon', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.facebook), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.pages), onPressed: () {}),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(link, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        )),
      ],
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('Home'), onTap: () {}),
            ListTile(title: const Text('Marketplace'), onTap: () {}),
            ListTile(title: const Text('Education'), onTap: () {}),
            ListTile(title: const Text('Contact'), onTap: () {}),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Join the Movement'),
            ),
          ],
        ),
      ),
    );
  }
}