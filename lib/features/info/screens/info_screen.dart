import 'package:bigger_bet/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

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
                  InfoHeader(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32),
                        Text(
                          'BASTIDORES',
                          style: TextStyle(
                            color: AppColors.neonGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        StylizedTitle(),
                        SizedBox(height: 16),
                        Text(
                          'Não somos apenas mais um site sobre odds e jackpots; somos o seu guia para decifrar os mistérios por trás dos algoritmos sedutores e das propagandas exageradas desse conteúdo hipnotizante.',
                          style: TextStyle(
                            color: AppColors.textSubtitle,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 32),
                        Center(
                          child: Icon(
                            Icons.keyboard_double_arrow_down,
                            color: AppColors.neonBlue,
                            size: 20,
                          ),
                        ),
                        SizedBox(height: 40),
                        MysteryCard(),
                        SizedBox(height: 40),
                        TricksSection(),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                  SupportSection(),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomNavBar(activeItem: NavBarItem.info),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoHeader extends StatelessWidget {
  const InfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
                      Border.all(color: AppColors.neonGreen.withValues(alpha: 0.5)),
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
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textGrey, size: 24),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}

class StylizedTitle extends StatelessWidget {
  const StylizedTitle({super.key});

  @override
  Widget build(BuildContext context) {
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
              ..color = AppColors.neonBlue.withValues(alpha: 0.7),
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
}

class MysteryCard extends StatelessWidget {
  const MysteryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.neonGreen.withValues(alpha: 0.05),
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
          const Row(
            children: [
              SmallInfoCard(icon: Icons.hub_outlined, label: 'SINCRONIA TOTAL'),
              SizedBox(width: 12),
              SmallInfoCard(icon: Icons.terminal, label: 'CORE NEURAL'),
            ],
          )
        ],
      ),
    );
  }
}

class SmallInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const SmallInfoCard({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
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
}

class TricksSection extends StatelessWidget {
  const TricksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ARMADILHAS PSICOLÓGICAS',
          style: TextStyle(
            color: AppColors.neonPink,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Como os Cassinos Te Viciam',
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Abaixo estão os três truques comportamentais mais usados pelas casas de apostas para fazer você continuar jogando mesmo perdendo tudo:',
          style: TextStyle(
            color: AppColors.textSubtitle,
            fontSize: 15,
            height: 1.5,
          ),
        ),
        SizedBox(height: 24),
        _TrickCard(
          icon: Icons.track_changes,
          title: 'Efeito Quase-Vitória (Near Miss)',
          description: 'A roleta quase para no prêmio, ou o balão decola quase no multiplicador alto. Isso faz seu cérebro liberar dopamina e achar que a vitória está muito próxima, forçando você a girar mais uma vez.',
          iconColor: AppColors.neonGreen,
        ),
        SizedBox(height: 16),
        _TrickCard(
          icon: Icons.trending_down,
          title: 'Perseguição de Perdas (Loss Chasing)',
          description: 'A crença irracional de que a "sorte vai mudar" e que a próxima aposta vai recuperar tudo o que foi perdido. É nesse momento que a maioria dos jogadores entra em falência total.',
          iconColor: AppColors.neonPink,
        ),
        SizedBox(height: 16),
        _TrickCard(
          icon: Icons.gamepad_outlined,
          title: 'Ilusão de Controle',
          description: 'Ao deixar você escolher a cor na roleta, as minas no campo ou a hora de retirar a aposta no crash, o jogo cria a ilusão de que você tem alguma habilidade envolvida. Na realidade, a banca controla 100% da probabilidade matemática.',
          iconColor: AppColors.neonBlue,
        ),
      ],
    );
  }
}

class _TrickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;

  const _TrickCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 13,
                    height: 1.4,
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

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUPORTE?',
            style: TextStyle(
              color: AppColors.neonPink,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Nossos agentes extraterrestres estão prontos para ignorar suas solicitações em mais de 400 dialetos estelares. Comunicação? Um conceito primitivo.',
            style: TextStyle(color: AppColors.textSubtitle, height: 1.5),
          ),
          SizedBox(height: 32),
          SupportRow(
            label: 'LATÊNCIA DE RESPOSTA',
            value: '4.2 ÉONS',
            valueColor: AppColors.neonPink,
          ),
          SizedBox(height: 12),
          SupportRow(
            label: 'PROTOCOLO',
            value: 'VOID',
            valueColor: AppColors.textWhite,
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class SupportRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const SupportRow({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
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
