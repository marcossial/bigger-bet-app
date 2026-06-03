import 'package:flutter/material.dart';
import 'package:bigger_bet/core/theme/app_theme.dart';
import 'package:bigger_bet/shared/widgets/custom_bottom_nav_bar.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PerfilHeader(),
                  SizedBox(height: 20),
                  PerfilAvatarSection(),
                  SizedBox(height: 30),
                  PerfilStatsGrid(),
                  SizedBox(height: 30),
                  PerfilAchievementsSection(),
                  SizedBox(height: 30),
                  PerfilActionsSection(),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomNavBar(activeItem: NavBarItem.profile),
            ),
          ],
        ),
      ),
    );
  }
}

class PerfilHeader extends StatelessWidget {
  const PerfilHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(color: AppColors.neonGreenDark, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGreen.withValues(alpha: 0.05),
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
          const Text(
            'PERFIL',
            style: TextStyle(
              color: AppColors.neonGreen,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class PerfilAvatarSection extends StatelessWidget {
  const PerfilAvatarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cardBackground,
              border: Border.all(color: AppColors.neonGreen, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonGreen.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            ),
            child: const Icon(Icons.face, size: 60, color: AppColors.textGrey),
          ),
          const SizedBox(height: 15),
          const Text(
            'JOGADOR #0042',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.neonGreenDark.withValues(alpha: 0.3)),
            ),
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
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'ATIVO • NÍVEL BROKE',
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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PROGRESSO DA DERROTA',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '86 XP',
                      style: TextStyle(
                        color: AppColors.neonGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.textWhite.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.86,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.neonGreen,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: const [
                          BoxShadow(color: AppColors.neonGreen, blurRadius: 4)
                        ],
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
}

class PerfilStatsGrid extends StatelessWidget {
  const PerfilStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estatísticas',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.casino_outlined,
                  label: 'TOTAL APOSTAS',
                  value: '0',
                  cardColor: AppColors.cardBlueDark,
                  borderColor: AppColors.buttonBlue.withValues(alpha: 0.1),
                  valueColor: AppColors.buttonBlueDark,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _StatCard(
                  icon: Icons.trending_down,
                  label: 'TAXA DE DERROTA',
                  value: '100%',
                  cardColor: AppColors.cardGreenDark,
                  borderColor: AppColors.neonGreen.withValues(alpha: 0.1),
                  valueColor: AppColors.neonGreen,
                  shadowColor: AppColors.neonGreen.withValues(alpha: 0.02),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.money_off,
                  label: 'TOTAL PERDIDO',
                  value: 'R\$ 0,00',
                  cardColor: AppColors.cardGreenDark,
                  borderColor: AppColors.neonGreen.withValues(alpha: 0.1),
                  valueColor: AppColors.neonGreen,
                  shadowColor: AppColors.neonGreen.withValues(alpha: 0.02),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _StatCard(
                  icon: Icons.calendar_today_outlined,
                  label: 'DIAS NO BURACO',
                  value: '1',
                  cardColor: AppColors.cardBlueDark,
                  borderColor: AppColors.buttonBlue.withValues(alpha: 0.1),
                  valueColor: AppColors.buttonBlueDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color cardColor;
  final Color borderColor;
  final Color valueColor;
  final Color? shadowColor;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.cardColor,
    required this.borderColor,
    required this.valueColor,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: shadowColor != null
            ? [
                BoxShadow(
                  color: shadowColor!,
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: valueColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  shadows: shadowColor != null
                      ? [
                          Shadow(
                            color: valueColor.withValues(alpha: 0.5),
                            blurRadius: 10,
                          )
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PerfilAchievementsSection extends StatelessWidget {
  const PerfilAchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Conquistas',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _AchievementCard(
                icon: Icons.emoji_events_outlined,
                label: 'PRIMEIRO PREJUÍZO',
                unlocked: true,
              ),
              SizedBox(width: 15),
              _AchievementCard(
                icon: Icons.arrow_downward,
                label: 'FUNDO DO POÇO',
                unlocked: false,
              ),
              SizedBox(width: 15),
              _AchievementCard(
                icon: Icons.sentiment_very_dissatisfied,
                label: 'SEM ESPERANÇA',
                unlocked: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool unlocked;

  const _AchievementCard({
    required this.icon,
    required this.label,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked
              ? AppColors.neonGreen.withValues(alpha: 0.3)
              : AppColors.cardBorder,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: unlocked ? AppColors.neonGreen : AppColors.textGrey,
              ),
              if (!unlocked)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.lock, size: 16, color: Colors.white70),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: unlocked ? AppColors.textWhite : AppColors.textGrey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unlocked ? 'DESBLOQUEADO' : 'BLOQUEADO',
            style: TextStyle(
              color: unlocked ? AppColors.neonGreen : AppColors.textSubtitle,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class PerfilActionsSection extends StatelessWidget {
  const PerfilActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _ActionRow(
            icon: Icons.edit_outlined,
            label: 'Editar Perfil',
            iconColor: AppColors.neonBlue,
          ),
          SizedBox(height: 12),
          _ActionRow(
            icon: Icons.history,
            label: 'Histórico de Apostas',
            iconColor: AppColors.neonBlue,
          ),
          SizedBox(height: 12),
          _ActionRow(
            icon: Icons.settings_outlined,
            label: 'Configurações',
            iconColor: AppColors.textGrey,
          ),
          SizedBox(height: 12),
          _ActionRow(
            icon: Icons.logout,
            label: 'Sair da Conta',
            iconColor: AppColors.neonPink,
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Icon(Icons.chevron_right, color: AppColors.textGrey),
        ],
      ),
    );
  }
}
