import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import 'brazilian_roulette_screen.dart';
import 'atomic_mines_screen.dart';
import 'money_abductor_screen.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  static Map<String, WidgetBuilder> get routes => {
        '/games/brazilian_roulette': (context) =>
            const BrazilianRouletteScreen(),
        '/games/atomic_mines': (context) => const AtomicMinesScreen(),
        '/games/money_abductor': (context) => const MoneyAbductorScreen(),
      };

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GamesHeader(),
                  SizedBox(height: 20),
                  GamesHeroCard(),
                  SizedBox(height: 30),
                  GamesListSection(),
                  SizedBox(height: 40),
                  EventosCatastroficosSection(),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomNavBar(activeItem: NavBarItem.games),
            ),
          ],
        ),
      ),
    );
  }
}

class GamesHeader extends StatelessWidget {
  const GamesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.neonGreen.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGreen.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child:
                    const Icon(Icons.adb, color: AppColors.neonGreen, size: 28),
              ),
              const SizedBox(width: 12),
              Text(
                'BIGGER BET',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textWhite,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      color: AppColors.neonGreen.withValues(alpha: 0.6),
                      blurRadius: 10,
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(Icons.face, color: AppColors.textGrey, size: 16),
          ),
        ],
      ),
    );
  }
}

class GamesHeroCard extends StatelessWidget {
  const GamesHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.neonGreen.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonGreen.withValues(alpha: 0.05),
              blurRadius: 30,
              spreadRadius: 2,
            )
          ],
          gradient: LinearGradient(
            colors: [
              AppColors.neonGreen.withValues(alpha: 0.05),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const Text(
              'O ESPAÇO É O DESTINO (DA SUA CONTA)',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'BEM-VINDO AO',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'BIGGER BET',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: AppColors.neonGreen,
                letterSpacing: -1,
                shadows: [
                  Shadow(
                    color: AppColors.neonGreen.withValues(alpha: 0.8),
                    blurRadius: 20,
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            Image.asset(
              'assets/images/alien_avatar.png',
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: AppColors.neonGreen, size: 60),
            ),
            const SizedBox(height: 16),
            const Text(
              'A primeira plataforma intergaláctica\nonde a probabilidade é apenas uma\nsugestão que ignoramos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [AppColors.buttonBlue, AppColors.buttonBlueDark],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.buttonBlue.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const Center(
                child: Text(
                  'VAMOS JUNTOS PERDER\nSEU DINHEIRO *',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '* COM A BIGGER BET VOCÊ SEMPRE SABE QUEM VAI GANHAR!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '(NÓS VAMOS GANHAR)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.neonGreen,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GamesListSection extends StatelessWidget {
  const GamesListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jogos',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Escolha como ser depenado',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              Text(
                'VER TUDO',
                style: TextStyle(
                  color: AppColors.neonGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _GameCircleIcon(
                title: 'BRAZILIAN\nROULETTE',
                icon: Icons.track_changes,
                iconColor: AppColors.buttonBlue,
                route: '/games/brazilian_roulette',
              ),
              _GameCircleIcon(
                title: 'ATOMIC\nMINES',
                icon: Icons.flare,
                iconColor: AppColors.neonGreen,
                route: '/games/atomic_mines',
              ),
              _GameCircleIcon(
                title: 'MONEY\nABDUCTOR',
                icon: Icons.rocket_launch,
                iconColor: AppColors.buttonBlue,
                route: '/games/money_abductor',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GameCircleIcon extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String route;

  const _GameCircleIcon({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 32),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class EventosCatastroficosSection extends StatelessWidget {
  const EventosCatastroficosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EVENTOS CATASTRÓFICOS',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              border:
                  Border.all(color: AppColors.neonGreen.withValues(alpha: 0.3)),
              gradient: LinearGradient(
                colors: [
                  AppColors.buttonBlue.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
