import 'package:flutter/material.dart';

class BiggerBetLogo extends StatelessWidget {
  const BiggerBetLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Neon green stroke layer (border effect)
        Text(
          'BIGGER  BET',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontFamily: 'Impact',
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = const Color(0xFF39FF14),
          ),
        ),
        // White fill layer
        const Text(
          'BIGGER  BET',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontFamily: 'Impact',
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
