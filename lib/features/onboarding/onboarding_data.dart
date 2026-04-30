class OnboardingPageData {
  final String imagePath;
  final String description;

  const OnboardingPageData({
    required this.imagePath,
    required this.description,
  });
}

final List<OnboardingPageData> onboardingPages = [
  const OnboardingPageData(
    imagePath: 'assets/images/onboarding_1.png',
    description: 'Retome o controle\ne se divirta enquanto o faz.',
  ),
  const OnboardingPageData(
    imagePath: 'assets/images/onboarding_2.png',
    description:
        'Entenda como funcionam as\ncasas de aposta e aprenda a\nidentificar os gatilhos.',
  ),
  const OnboardingPageData(
    imagePath: 'assets/images/onboarding_3.png',
    description:
        'Supere desafios diários,\nacompanhe seu progresso e\nganhe recompensas por sua\ndedicação.',
  ),
];
