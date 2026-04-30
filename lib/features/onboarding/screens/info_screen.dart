import 'package:bigger_bet/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/auth_colors.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    // ── Hero Section ──────────────────────────────────────────
                    const Text(
                      'BASTIDORES',
                      style: TextStyle(
                        color: AppColors.neonGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    _buildStylizedTitle(),
                    const SizedBox(height: 16),
                    const Text(
                      'Não somos apenas mais um site sobre odds e jackpots; somos o seu guia para decifrar os mistérios por trás dos algoritmos sedutores e das propagandas exageradas desse conteúdo hipnotizante.',
                      style: TextStyle(
                        color: AppColors.textSubtitle,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Action Link ───────────────────────────────────────────
                    Center(
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.keyboard_double_arrow_down,
                            color: AppColors.neonBlue, size: 20),
                        label: const Text(
                          'ENTENDA MELHOR',
                          style: TextStyle(
                            color: AppColors.neonBlue,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ── Mystery Card ──────────────────────────────────────────
                    _buildMysteryCard(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // ── Support Section ───────────────────────────────────────────
              _buildSupportSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AppColors.neonGreen.withOpacity(0.5)),
                ),
                child:
                    const Icon(Icons.adb, color: AppColors.neonGreen, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'BIGGER BET',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const Icon(Icons.face, color: AppColors.textGrey, size: 20),
        ],
      ),
    );
  }

  Widget _buildStylizedTitle() {
    return Stack(
      children: [
        Text(
          'BIGGER BET',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1
              ..color = AppColors.neonBlue.withOpacity(0.7),
          ),
        ),
        const Text(
          'BIGGER BET',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w900,
            color: AppColors.textWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildMysteryCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.neonGreen.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'O QUE VOCÊ NÃO VÊ',
            style: TextStyle(
              color: AppColors.neonGreen,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Desvendando os\nMistérios Digitais',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Navegue por nossas análises, e desvende as táticas por trás dos anúncios que te mantêm preso ao jogo e os algoritmos que, na realidade, não te dão chance alguma.',
            style: TextStyle(color: AppColors.textGrey, height: 1.4),
          ),
          const SizedBox(height: 24),

          // Quote section
          Row(
            children: [
              Container(width: 3, height: 40, color: AppColors.neonGreen),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  '"A casa nunca perde, porque a casa é o próprio código."',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Sub-cards
          Row(
            children: [
              _buildSmallCard(Icons.hub_outlined, 'SINCRONIA TOTAL'),
              const SizedBox(width: 12),
              _buildSmallCard(Icons.terminal, 'CORE NEURAL'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSmallCard(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.neonGreen, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SUPORTE?',
            style: TextStyle(
              color: AppColors.neonPink,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nossos agentes extraterrestres estão prontos para ignorar suas solicitações em mais de 400 dialetos estelares. Comunicação? Um conceito primitivo.',
            style: TextStyle(color: AppColors.textSubtitle, height: 1.5),
          ),
          const SizedBox(height: 32),
          _buildSupportRow(
              'LATÊNCIA DE RESPOSTA', '4.2 ÉONS', AppColors.neonPink),
          const SizedBox(height: 12),
          _buildSupportRow('PROTOCOLO', 'VOID', AppColors.textWhite),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSupportRow(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
