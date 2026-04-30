import 'package:bigger_bet/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BiggerBetHome extends StatelessWidget {
  const BiggerBetHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Corpo da página rolável
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                  bottom: 100), // Espaço para o menu inferior
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildBalanceSection(),
                  const SizedBox(height: 40),
                  _buildStatsSection(),
                  const SizedBox(height: 30),
                  _buildAssetsSection(),
                ],
              ),
            ),

            // Bottom Navigation Bar Customizada
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(color: AppColors.neonGreenDark, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGreen.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
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
                    border:
                        Border.all(color: AppColors.neonGreen.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonGreen.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ]),
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
                      color: AppColors.neonGreen.withOpacity(0.6),
                      blurRadius: 10,
                    )
                  ],
                ),
              ),
            ],
          ),
          const Icon(Icons.face, color: AppColors.textGrey),
        ],
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Center(
      child: Column(
        children: [
          const Text(
            'SALDO ATUAL DE DESESPERO',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'R\$ 0,42',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w900,
              color: AppColors.neonGreen,
              letterSpacing: -1.5,
              shadows: [
                Shadow(
                  color: AppColors.neonGreen.withOpacity(0.8),
                  blurRadius: 25,
                ),
                Shadow(
                  color: AppColors.neonGreen.withOpacity(0.4),
                  blurRadius: 50,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color:
                    Colors.black, // Mantido preto puro para contraste do badge
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: AppColors.neonGreenDark.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGreen.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ]),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: AppColors.neonGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonGreen,
                          blurRadius: 5,
                        )
                      ]),
                ),
                const SizedBox(width: 8),
                const Text(
                  'RISCO DE FALÊNCIA: CRÍTICO',
                  style: TextStyle(
                    color: AppColors.neonGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.insights, color: AppColors.buttonBlue, size: 20),
              SizedBox(width: 8),
              Text(
                'Estatísticas',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 130,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBlueDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.buttonBlue.withOpacity(0.1)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.casino_outlined, color: AppColors.buttonBlue),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DIAS DE SORTE',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '0',
                            style: TextStyle(
                              color: AppColors.buttonBlueDark,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Container(
                  height: 130,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.cardGreenDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.neonGreen.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonGreen.withOpacity(0.02),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.sentiment_very_dissatisfied,
                          color: AppColors.neonGreen),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'NÍVEL DE TRISTEZA',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '86',
                                style: TextStyle(
                                    color: AppColors.neonGreen,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    shadows: [
                                      Shadow(
                                          color: AppColors.neonGreen
                                              .withOpacity(0.5),
                                          blurRadius: 10)
                                    ]),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 6, left: 4),
                                child: Text('XP',
                                    style: TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 4,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.textWhite.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.86,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.neonGreen,
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: AppColors.neonGreen,
                                          blurRadius: 4)
                                    ]),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAssetsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.inventory_2_outlined,
                      color: AppColors.buttonBlue, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Meus Bens',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '3 ITENS RESTANTES',
                style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 15),
          _buildAssetItem(
              Icons.home_outlined, 'Uma Casa Inteira', 'Valor: R\$ 450.000'),
          const SizedBox(height: 15),
          _buildAssetItem(Icons.directions_car_outlined, 'Carro do Ano',
              'Valor: R\$ 120.000'),
        ],
      ),
    );
  }

  Widget _buildAssetItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, color: AppColors.textGrey, size: 28),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSubtitle,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.neonGreen,
            side: const BorderSide(color: AppColors.neonGreen, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: Text(
            'VENDER',
            style:
                TextStyle(fontSize: 12, fontWeight: FontWeight.bold, shadows: [
              Shadow(color: AppColors.neonGreen.withOpacity(0.5), blurRadius: 5)
            ]),
          ),
        )
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 90,
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 15),
      decoration: BoxDecoration(
          color: AppColors.bottomNavBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          border: Border(
            top: BorderSide(
                color: AppColors.neonGreen.withOpacity(0.2), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonGreen.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
                color: AppColors.neonGreen,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGreen.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ]),
            child: const Row(
              children: [
                Icon(Icons.home, color: Colors.black, size: 20),
                SizedBox(width: 8),
                Text(
                  'Início',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
          const Icon(Icons.sports_esports_outlined,
              color: AppColors.textGrey, size: 26),
          const Icon(Icons.chat_bubble_outline,
              color: AppColors.textGrey, size: 24),
          const Icon(Icons.face, color: AppColors.textGrey, size: 26),
        ],
      ),
    );
  }
}
