import 'package:bigger_bet/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../games/utils/finance_manager.dart';

class BiggerBetHome extends StatefulWidget {
  const BiggerBetHome({super.key});

  @override
  State<BiggerBetHome> createState() => _BiggerBetHomeState();
}

class _BiggerBetHomeState extends State<BiggerBetHome> {
  double _saldo = 1000.00;
  Set<String> _bensVendidos = {};

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    final saldo = await FinanceManager.getSaldo();
    final casaVendida = await FinanceManager.isBemVendido('casa');
    final carroVendido = await FinanceManager.isBemVendido('carro');
    final telefoneVendido = await FinanceManager.isBemVendido('telefone');
    
    Set<String> vendidos = {};
    if (casaVendida) vendidos.add('casa');
    if (carroVendido) vendidos.add('carro');
    if (telefoneVendido) vendidos.add('telefone');

    if (mounted) {
      setState(() {
        _saldo = saldo;
        _bensVendidos = vendidos;
      });
    }
  }

  void _venderBem(double valor, String idBem, String mensagem) async {
    setState(() {
      _saldo += valor;
      _bensVendidos.add(idBem);
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            mensagem, 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
          ),
          backgroundColor: AppColors.neonGreenDark,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 90, left: 20, right: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    await FinanceManager.saveSaldo(_saldo);
    await FinanceManager.setBemVendido(idBem);
  }

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
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 30),
                  BalanceSection(saldo: _saldo),
                  const SizedBox(height: 40),
                  const StatsSection(),
                  const SizedBox(height: 30),
                  AssetsSection(
                    onVenderBem: _venderBem,
                    bensVendidos: _bensVendidos,
                  ),
                ],
              ),
            ),

            // Bottom Navigation Bar Customizada
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomNavBar(activeItem: NavBarItem.home),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

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
                        color: AppColors.neonGreen.withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonGreen.withValues(alpha: 0.2),
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
                      color: AppColors.neonGreen.withValues(alpha: 0.6),
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
}

class BalanceSection extends StatelessWidget {
  final double saldo;

  const BalanceSection({super.key, required this.saldo});

  @override
  Widget build(BuildContext context) {
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
            'R\$ ${saldo.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w900,
              color: AppColors.neonGreen,
              letterSpacing: -1.5,
              shadows: [
                Shadow(
                  color: AppColors.neonGreen.withValues(alpha: 0.8),
                  blurRadius: 25,
                ),
                Shadow(
                  color: AppColors.neonGreen.withValues(alpha: 0.4),
                  blurRadius: 50,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: AppColors.neonGreenDark.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGreen.withValues(alpha: 0.05),
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
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _mostrarPopUpSaque(context),
            icon: const Icon(Icons.monetization_on_outlined, color: Colors.black, size: 16),
            label: const Text(
              'SACAR SALDO (PIX)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonGreen,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarPopUpSaque(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.neonPink),
            SizedBox(width: 8),
            Text(
              'SAQUE INDISPONÍVEL',
              style: TextStyle(color: AppColors.neonPink, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        content: const Text(
          'Estamos enfrentando instabilidade técnica nos saques via PIX devido ao alto volume de transferências de bônus para a diretoria. Que tal continuar apostando para dobrar seu saldo enquanto nosso servidor de pagamentos está "temporariamente" fora do ar? Confia!',
          style: TextStyle(color: AppColors.textWhite, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('TENTAR DE NOVO', style: TextStyle(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonGreen,
              foregroundColor: Colors.black,
            ),
            child: const Text('CONTINUAR APOSTANDO', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                        color: AppColors.buttonBlue.withValues(alpha: 0.1)),
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
                          color: AppColors.neonGreen.withValues(alpha: 0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonGreen.withValues(alpha: 0.02),
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
                                              .withValues(alpha: 0.5),
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
                              color: AppColors.textWhite.withValues(alpha: 0.1),
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
}

class AssetsSection extends StatelessWidget {
  final void Function(double valor, String idBem, String mensagem) onVenderBem;
  final Set<String> bensVendidos;

  const AssetsSection({super.key, required this.onVenderBem, required this.bensVendidos});

  @override
  Widget build(BuildContext context) {
    int itensRestantes = 3 - bensVendidos.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
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
                '$itensRestantes ITEN${itensRestantes == 1 ? '' : 'S'} RESTANTE${itensRestantes == 1 ? '' : 'S'}',
                style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 15),
          AssetItemCard(
            icon: Icons.home_outlined,
            title: 'Uma Casa Inteira',
            subtitle: 'Valor: R\$ 450.000',
            isSold: bensVendidos.contains('casa'),
            onSell: () => onVenderBem(450000.00, 'casa', 'Ótima escolha vender sua casa, você nem precisava dela mesmo!'),
          ),
          const SizedBox(height: 15),
          AssetItemCard(
            icon: Icons.directions_car_outlined,
            title: 'Carro do Ano',
            subtitle: 'Valor: R\$ 120.000',
            isSold: bensVendidos.contains('carro'),
            onSell: () => onVenderBem(120000.00, 'carro', 'Carro vendido com sucesso! Pelo menos você não precisa mais pagar o IPVA.'),
          ),
          const SizedBox(height: 15),
          AssetItemCard(
            icon: Icons.smartphone_outlined,
            title: 'Telefone Celular',
            subtitle: 'Valor: R\$ 4.500',
            isSold: bensVendidos.contains('telefone'),
            onSell: () => onVenderBem(4500.00, 'telefone', 'Parabéns por vender seu telefone, agora você tem o saldo necessário para jogar mais. Mas... como você vai jogar sem ele, né?'),
          ),
        ],
      ),
    );
  }
}

class AssetItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onSell;
  final bool isSold;

  const AssetItemCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onSell,
    required this.isSold,
  });

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(
                  color: isSold ? AppColors.textGrey : AppColors.textWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: isSold ? TextDecoration.lineThrough : null,
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
          onPressed: () {
            if (isSold) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Você já vendeu isso! Não tem como vender duas vezes.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  backgroundColor: AppColors.neonPink,
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(bottom: 90, left: 20, right: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            } else {
              onSell();
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: isSold ? AppColors.textGrey : AppColors.neonGreen,
            side: BorderSide(color: isSold ? AppColors.textGrey.withValues(alpha: 0.5) : AppColors.neonGreen, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: Text(
            isSold ? 'VENDIDO' : 'VENDER',
            style:
                TextStyle(fontSize: 12, fontWeight: FontWeight.bold, shadows: isSold ? [] : [
              Shadow(color: AppColors.neonGreen.withValues(alpha: 0.5), blurRadius: 5)
            ]),
          ),
        )
      ],
    );
  }
}
