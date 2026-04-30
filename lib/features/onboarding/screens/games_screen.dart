import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

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
                  _buildGamesSection(),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.adb, color: AppColors.neonGreen, size: 28),
          const SizedBox(width: 10),
          const Text(
            'BIGGER BET',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.face, color: AppColors.textGrey),
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
  Widget _buildGamesSection() {
    final games = [
      {'icon': Icons.casino, 'title': 'UNFAIR ODDS'},
      {'icon': Icons.style, 'title': 'POKER BLUFF'},
      {'icon': Icons.sports_soccer, 'title': 'WRONG BETS'},
      {'icon': Icons.flag, 'title': 'BRAZILIAN'},
      {'icon': Icons.warning, 'title': 'PYRAMID'},
      {'icon': Icons.casino_outlined, 'title': 'ADDICTIVE'},
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Escolha como ser depenado',
            style: TextStyle(color: AppColors.textGrey, fontSize: 12),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: games.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final game = games[index];

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      game['icon'] as IconData,
                      color: AppColors.neonGreen,
                      size: 30,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      game['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 11,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ───────────────── NAV BAR ─────────────────
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.only(bottom: 20, top: 15),
      decoration: BoxDecoration(
        color: AppColors.bottomNavBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
