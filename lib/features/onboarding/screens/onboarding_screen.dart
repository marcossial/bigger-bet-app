import 'package:flutter/material.dart';
import '../onboarding_data.dart';
import '../widgets/bigger_bet_logo.dart';
import '../widgets/continue_button.dart';
import '../widgets/page_indicator.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _handleContinue() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // ── Logo ──────────────────────────────────────────────────────
              const SizedBox(height: 12),
              const BiggerBetLogo(),
              const SizedBox(height: 16),

              // ── Illustration card ─────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingPages.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    return _OnboardingPage(
                      data: onboardingPages[index],
                      screenWidth: screenWidth,
                    );
                  },
                ),
              ),

              // ── Page indicator ────────────────────────────────────────────
              const SizedBox(height: 20),
              OnboardingPageIndicator(
                pageCount: onboardingPages.length,
                currentPage: _currentPage,
              ),

              // ── Continue button ───────────────────────────────────────────
              const SizedBox(height: 20),
              ContinueButton(onPressed: _handleContinue),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single onboarding page: card + description text
// ─────────────────────────────────────────────────────────────────────────────

class _OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final double screenWidth;

  const _OnboardingPage({required this.data, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Rounded illustration card
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF39FF14).withOpacity(0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF39FF14).withOpacity(0.15),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                data.imagePath,
                fit: BoxFit.cover,
                // Fallback while assets aren't bundled yet
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2D1B69), Color(0xFFFF6B35)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.white38,
                      size: 64,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Description text
        const SizedBox(height: 24),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
