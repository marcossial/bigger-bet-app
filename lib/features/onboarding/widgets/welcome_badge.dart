import 'package:flutter/material.dart';
import '../../../core/theme/auth_colors.dart';

class WelcomeBadge extends StatelessWidget {
  final String text;

  const WelcomeBadge({super.key, this.text = 'BEM-VINDO AO JOGO'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AuthColors.neonGreen,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AuthColors.neonGreen.withOpacity(0.5),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
