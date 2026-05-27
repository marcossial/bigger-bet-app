import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'brazilian_roulette_screen.dart';
import 'atomic_mines_screen.dart';
import 'money_abductor_screen.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  static Map<String, WidgetBuilder> get routes => {
        '/games/brazilian_roulette': (context) => const BrazilianRouletteScreen(),
        '/games/atomic_mines': (context) => const AtomicMinesScreen(),
        '/games/money_abductor': (context) => const MoneyAbductorScreen(),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildHeroCard(),
                  const SizedBox(height: 30),
                  _buildGamesSection(context),
                ],
              ),
            ),

            // Bottom Nav
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomNavBar(context),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── HEADER ─────────────────
  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.adb, color: AppColors.neonGreen, size: 28),
          SizedBox(width: 10),
          Text(
            'BIGGER BET',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Icon(Icons.face, color: AppColors.textGrey),
        ],
      ),
    );
  }

  // ───────────────── HERO CARD ─────────────────
  Widget _buildHeroCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.neonGreen.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonGreen.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 2,
            )
          ],
          gradient: const LinearGradient(
            colors: [Color(0xFF0D0D0D), Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const Text(
              'BEM-VINDO AO',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'BIGGER BET',
              style: TextStyle(
                color: AppColors.neonGreen,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(
                    color: AppColors.neonGreen.withOpacity(0.8),
                    blurRadius: 20,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'A primeira plataforma intergaláctica\nonde a probabilidade é apenas uma\nsugestão que ignoramos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // BOTÃO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B5EFF), Color(0xFF3A4EDB)],
                ),
              ),
              child: const Center(
                child: Text(
                  'VAMOS JUNTOS PERDER SEU DINHEIRO *',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              '* COM A BIGGER BET VOCÊ SEMPRE SABE QUEM VAI GANHAR!',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 9,
              ),
            ),
            const Text(
              '(NÓS VAMOS GANHAR)',
              style: TextStyle(
                color: AppColors.neonGreen,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── GAMES GRID ─────────────────
  Widget _buildGamesSection(BuildContext context) {
    final games = [
      {
        'title': 'BRAZILIAN ROULETTE',
        'subtitle': 'A roleta que sempre cai no zero',
        'route': '/games/brazilian_roulette',
        'image': 'assets/images/brazilian_roulette.png'
      },
      {
        'title': 'ATOMIC MINES',
        'subtitle': 'Onde a primeira casa já é bomba',
        'route': '/games/atomic_mines',
        'image': 'assets/images/atomic_mines.png'
      },
      {
        'title': 'MONEY ABDUCTOR',
        'subtitle': 'Crash instantâneo em 1.01x',
        'route': '/games/money_abductor',
        'image': 'assets/images/money_abductor.png'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jogos',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Os mais justos da galáxia',
            style: TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ...games.map((game) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, game['route'] as String);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF111111),
                    border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background Image
                        Image.asset(
                          game['image'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF1A1A1A),
                              child: const Center(
                                child: Icon(Icons.image_not_supported, color: AppColors.textGrey, size: 50),
                              ),
                            );
                          },
                        ),
                        // Dark Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.9),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        // Text Info
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                game['title'] as String,
                                style: const TextStyle(
                                  color: AppColors.neonGreen,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                game['subtitle'] as String,
                                style: const TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Play Button
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.neonGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'JOGAR',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // ───────────────── NAV BAR ─────────────────
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.only(bottom: 20, top: 15),
      decoration: const BoxDecoration(
        color: AppColors.bottomNavBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            icon: const Icon(Icons.home, color: AppColors.textGrey),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.neonGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.sports_esports, color: Colors.black),
          ),
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/info'),
            icon: const Icon(Icons.chat_bubble_outline,
                color: AppColors.textGrey),
          ),
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/perfil'),
            icon: const Icon(Icons.face, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
