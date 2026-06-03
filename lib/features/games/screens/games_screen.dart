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
}

class GamesHeroCard extends StatelessWidget {
  const GamesHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.neonGreen.withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonGreen.withValues(alpha: 0.2),
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
                    color: AppColors.neonGreen.withValues(alpha: 0.8),
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
}

class GamesListSection extends StatelessWidget {
  const GamesListSection({super.key});

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: games.map((game) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, game['route'] as String);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFF111111),
                        border: Border.all(
                            color: AppColors.neonGreen.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
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
                            Image.asset(
                              game['image'] as String,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(0xFF1A1A1A),
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported,
                                        color: AppColors.textGrey, size: 30),
                                  ),
                                );
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.9),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    game['title'] as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.neonGreen,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.neonGreen,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'JOGAR',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
