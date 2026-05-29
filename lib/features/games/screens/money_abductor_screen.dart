import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MoneyAbductorScreen extends StatefulWidget {
  const MoneyAbductorScreen({super.key});

  @override
  State<MoneyAbductorScreen> createState() => _MoneyAbductorScreenState();
}

class _MoneyAbductorScreenState extends State<MoneyAbductorScreen> {
  double _multiplier = 1.00;
  bool _flying = false;
  bool _crashed = false;
  Timer? _timer;

  void _start() {
    if (_flying) return;
    setState(() {
      _multiplier = 1.00;
      _flying = true;
      _crashed = false;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _multiplier += 0.01;
      });
      // Crash at 1.01 immediately
      if (_multiplier >= 1.01) {
        timer.cancel();
        setState(() {
          _flying = false;
          _crashed = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Money Abductor',
            style: TextStyle(color: AppColors.textWhite)),
        iconTheme: const IconThemeData(color: AppColors.neonGreen),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Retire antes de crashar!',
              style: TextStyle(color: AppColors.textGrey, fontSize: 16),
            ),
            const SizedBox(height: 50),
            Text(
              '${_multiplier.toStringAsFixed(2)}x',
              style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: _crashed ? Colors.red : AppColors.neonGreen,
                  shadows: [
                    Shadow(
                      color: _crashed
                          ? Colors.red.withValues(alpha: 0.5)
                          : AppColors.neonGreen.withValues(alpha: 0.5),
                      blurRadius: 20,
                    )
                  ]),
            ),
            if (_crashed) ...[
              const SizedBox(height: 20),
              const Text(
                'ABDUZIDO!',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'O alienígena levou seu saldo.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
            ],
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: _flying || _crashed ? null : _start,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                'APOSTAR',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (_crashed)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _multiplier = 1.0;
                      _crashed = false;
                    });
                  },
                  child: const Text('Tentar de novo',
                      style:
                          TextStyle(color: AppColors.textGrey, fontSize: 16)),
                ),
              )
          ],
        ),
      ),
    );
  }
}
