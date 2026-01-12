import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../config/theme.dart';

class OnboardingRewardsScreen extends StatelessWidget {
  const OnboardingRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width >= 864;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            _buildHeader(context),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 80 : 16,
                  vertical: 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: isLargeScreen
                        ? _buildDesktopLayout(context)
                        : _buildMobileLayout(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeIn(
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.recycling, color: AppTheme.primary, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  'TrashCash',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          FadeIn(
            delay: const Duration(milliseconds: 300),
            child: TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              child: const Text('Skip Intro'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: Image
        Expanded(
          child: FadeInLeft(
            duration: const Duration(milliseconds: 800),
            child: _buildHeroImage(),
          ),
        ),
        const SizedBox(width: 60),
        // Right: Content
        Expanded(
          child: FadeInRight(
            duration: const Duration(milliseconds: 800),
            child: _buildContent(context),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        FadeIn(child: _buildHeroImage()),
        const SizedBox(height: 40),
        FadeInUp(child: _buildContent(context)),
      ],
    );
  }

  Widget _buildHeroImage() {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFF0F4F0),
                  child: const Icon(Icons.recycling, size: 80, color: AppTheme.primary),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: AppTheme.primary, size: 14),
                      SizedBox(width: 6),
                      Text(
                        'Douala, Cameroon',
                        style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 0.5),
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

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Bar
        _buildProgressBar(),
        const SizedBox(height: 32),

        // Heading
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
            children: [
              const TextSpan(text: 'Turn Trash into '),
              TextSpan(
                text: 'Cash',
                style: TextStyle(
                  color: AppTheme.primary,
                  shadows: [
                    Shadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Subtitle
        Text(
          'Every kilogram counts. Bring your sorted plastics and metals to a TrashCash Hub. We weigh it on the spot, and you get instant credits in your digital wallet to spend on groceries or withdraw as cash.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF6B7280),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),

        // Step Cards
        _buildStepCard(
          icon: Icons.delete_outline,
          number: '1',
          title: 'Bring Waste',
          description: 'Bring your sorted plastics and metals to a local TrashCash Hub nearby.',
        ),
        const SizedBox(height: 16),
        _buildStepCard(
          icon: Icons.scale,
          number: '2',
          title: 'Get Weighed',
          description: 'Our agents weigh your recyclables instantly on verified digital scales.',
        ),
        const SizedBox(height: 16),
        _buildStepCard(
          icon: Icons.account_balance_wallet,
          number: '3',
          title: 'Earn Credit',
          description: 'Receive instant credits in your digital wallet to spend or withdraw.',
        ),
        const SizedBox(height: 32),

        // Action Buttons
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Onboarding Progress',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              '2 of 3',
              style: TextStyle(fontSize: 14, color: const Color(0xFF6B7280)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.66,
            minHeight: 8,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard({
    required IconData icon,
    required String number,
    required String title,
    required String description,
  }) {
    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$number. $title',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111811),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.5,
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

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Back'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/onboarding-impact'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}