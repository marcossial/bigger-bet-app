import 'package:flutter/material.dart';

class AlienAvatarCard extends StatelessWidget {
  const AlienAvatarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF39FF14), Color(0xFF1E90FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF39FF14).withOpacity(0.35),
            blurRadius: 28,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: const Color(0xFF1E90FF).withOpacity(0.25),
            blurRadius: 28,
            spreadRadius: 2,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Container(
          color: const Color(0xFF151825),
          child: Image.asset(
            'assets/images/alien_avatar.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const _AlienFallback(),
          ),
        ),
      ),
    );
  }
}

class _AlienFallback extends StatelessWidget {
  const _AlienFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF151825),
      child: const Center(
        child: Text('👽', style: TextStyle(fontSize: 72)),
      ),
    );
  }
}
