import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../config/theme.dart';

class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width >= 1024;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // Decorative gradient blob
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: size.width * 0.5,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primary.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context),

                // Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isLargeScreen ? 80 : 24,
                      vertical: 32,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
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
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
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
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          FadeIn(
            delay: const Duration(milliseconds: 300),
            child: TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              child: Text(
                'Skip Intro',
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FadeInLeft(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildContent(context),
                const SizedBox(height: 48),
                _buildButtons(context),
                const SizedBox(height: 48),
                _buildIndicator(0),
              ],
            ),
          ),
        ),
        const SizedBox(width: 80),
        Expanded(child: FadeInRight(child: _buildImage())),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FadeIn(child: _buildImage()),
          const SizedBox(height: 40),
          FadeInUp(
            child: Column(
              children: [
                _buildContent(context),
                const SizedBox(height: 32),
                _buildButtons(context),
                const SizedBox(height: 32),
                _buildIndicator(0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
            children: [
              const TextSpan(text: 'Turn Your Trash into '),
              TextSpan(
                text: 'Cash',
                style: TextStyle(
                  color: AppTheme.primary,
                  shadows: [Shadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 20)],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Join Cameroon\'s first digital marketplace connecting waste collectors with buyers. Recycle, earn rewards, and clean up your city.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 18,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/onboarding-rewards'),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          child: Text('Skip Intro', style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildIndicator(int active) {
    return Row(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          height: 8,
          width: index == active ? 32 : 8,
          decoration: BoxDecoration(
            color: index == active ? AppTheme.primary : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppTheme.surfaceDark,
                  child: const Icon(Icons.recycling, size: 100, color: AppTheme.primary),
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
                bottom: 24,
                left: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: AppTheme.primary, size: 16),
                      SizedBox(width: 6),
                      Text('Douala, Cameroon', style: TextStyle(color: Colors.white, fontSize: 12)),
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
}