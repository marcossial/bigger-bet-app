import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class BrazilianRouletteScreen extends StatefulWidget {
  const BrazilianRouletteScreen({super.key});

  @override
  State<BrazilianRouletteScreen> createState() =>
      _BrazilianRouletteScreenState();
}

class _BrazilianRouletteScreenState extends State<BrazilianRouletteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _angle = 0;
  bool _spinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.addListener(() {
      setState(() {
        _angle = _controller.value * 2 * pi * 5; // 5 full rotations
      });
    });
  }

  void _spin() {
    if (_spinning) return;
    setState(() => _spinning = true);
    _controller.forward(from: 0).then((_) {
      setState(() => _spinning = false);
      _showResult();
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('O BANCO VENCEU!',
            style: TextStyle(
                color: AppColors.neonGreen, fontWeight: FontWeight.bold)),
        content: const Text(
            'Como esperado, a roleta parou no verde (0). O sistema ficou com seu dinheiro.',
            style: TextStyle(color: AppColors.textWhite)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ACEITAR O DESTINO',
                style: TextStyle(color: AppColors.neonGreen)),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Brazilian Roulette',
            style: TextStyle(color: AppColors.textWhite)),
        iconTheme: const IconThemeData(color: AppColors.neonGreen),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Aposte no vermelho ou preto.',
              style: TextStyle(color: AppColors.textGrey, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Spoiler: Sempre dá zero.',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Transform.rotate(
              angle: _angle,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.neonGreen, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGreen.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ],
                  gradient: const SweepGradient(
                    colors: [
                      Colors.red,
                      Colors.black,
                      Colors.red,
                      Colors.black,
                      Colors.green,
                      Colors.red
                    ],
                    stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                  ),
                ),
                child: const Center(
                  child: Text('0',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: _spinning ? null : _spin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                'GIRAR ROLETA',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
