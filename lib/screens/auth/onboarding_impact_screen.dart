import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui';
import '../../config/theme.dart';

class OnboardingImpactScreen extends StatelessWidget {
  const OnboardingImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width >= 1024;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Main Content - Split Screen
            Expanded(
              child: isLargeScreen
                  ? Row(
                children: [
                  // Left: Hero Image with Stats
                  Expanded(
                    child: _buildHeroSide(context),
                  ),
                  // Right: Form Side
                  Expanded(
                    child: _buildFormSide(context),
                  ),
                ],
              )
                  : Column(
                children: [
                  // Mobile: Image at top
                  Expanded(
                    flex: 2,
                    child: _buildHeroSide(context),
                  ),
                  // Mobile: Content at bottom
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: AppTheme.backgroundDark,
                      child: _buildFormSide(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeIn(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.recycling, color: AppTheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'TrashCash',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          FadeIn(
            delay: const Duration(milliseconds: 300),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Need Help?',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSide(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.network(
            'https://images.unsplash.com/photo-1518331647614-7a1f04cd34cf?w=1200',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppTheme.surfaceDark,
              child: const Icon(Icons.eco, size: 100, color: AppTheme.primary),
            ),
          ),
        ),

        // Dark Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),

        // Floating Stats Cards with Glassmorphism
        Positioned(
          bottom: 48,
          left: 24,
          right: 24,
          child: FadeInUp(
            duration: const Duration(milliseconds: 1000),
            delay: const Duration(milliseconds: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Two Cards Row
                Row(
                  children: [
                    Expanded(
                      child: _buildGlassCard(
                        icon: Icons.recycling,
                        label: 'Waste Collected',
                        value: '500kg+',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildGlassCard(
                        icon: Icons.payments,
                        label: 'Paid Out',
                        value: '\$200k',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Full Width Card
                _buildGlassCard(
                  icon: Icons.eco,
                  label: 'Environmental Impact',
                  value: '120kg CO2 Reduced',
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({
    required IconData icon,
    required String label,
    required String value,
    bool isFullWidth = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: isFullWidth
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.primary, size: 20),
              ),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppTheme.primary, size: 24),
              const SizedBox(height: 12),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSide(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            child: FadeInRight(
              duration: const Duration(milliseconds: 800),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  // Progress
                  _buildProgress(),
              const SizedBox(height: 32),

              // Heading
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                  children: [
                    const TextSpan(text: 'Together, We Clean '),
                    TextSpan(
                      text: 'Our Cities.',
                      style: TextStyle(
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [AppTheme.primary, const Color(0xFF0FB80F)],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                  "By joining TrashCash, you aren't just managing waste—you are building a cleaner future for Cameroon and earning from it. Your impact starts now.",
              style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),

          // Role Recap
          _buildRoleRecap(),
          const SizedBox(height: 32),

          // Launch Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.backgroundDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                shadowColor: AppTheme.primary.withOpacity(0.3),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Launch TrashCash',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.rocket_launch, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Back Button
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back to Role Selection'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          ],
        ),
      ),
    ),
    ),
    ),
    );
  }

  Widget _buildProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Step 3 of 3',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Almost There',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 1.0,
            minHeight: 8,
            backgroundColor: AppTheme.surfaceDark,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleRecap() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Joining as',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Verified Collector',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Change',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}