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
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const BiggerBetLogo(),
              const SizedBox(height: 16),
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
              const SizedBox(height: 20),
              OnboardingPageIndicator(
                pageCount: onboardingPages.length,
                currentPage: _currentPage,
              ),
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

class _OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final double screenWidth;

  const _OnboardingPage({required this.data, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              // Fundo sólido adicionado aqui para bloquear o vazamento da sombra
              color: AppColors.background,
              borderRadius: BorderRadius.circular(24),
              border: const Border(
                top: BorderSide(
                  color: Color(0xCC39FF14),
                  width: 3.0,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF39FF14).withValues(alpha: 0.15),
                  offset: const Offset(0, -4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white, // O topo fica 100% visível
                      Colors.white, // Continua visível pelo corpo da imagem
                      Colors.transparent, // Fica transparente no finalzinho
                    ],
                    stops: [
                      0.0,
                      0.85,
                      1.0
                    ], // O fade ocorre apenas nos últimos 15%
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  data.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2D1B69),
                          Color(0xFF2D1B69),
                          Color(0xF2FF6B35),
                          Color(0x1AFF6B35),
                        ],
                        stops: [0.0, 0.33, 0.66, 1.0],
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
        ),
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
