import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

enum NavBarItem { home, games, info, profile }

class CustomBottomNavBar extends StatelessWidget {
  final NavBarItem activeItem;

  const CustomBottomNavBar({super.key, required this.activeItem});

  @override
  Widget build(BuildContext context) {
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
          top:
              BorderSide(color: AppColors.neonGreen.withValues(alpha: 0.2), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGreen.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItemWidget(
            item: NavBarItem.home,
            activeItem: activeItem,
            icon: Icons.home,
            label: 'Início',
            route: '/home',
          ),
          _NavBarItemWidget(
            item: NavBarItem.games,
            activeItem: activeItem,
            icon: Icons.sports_esports_outlined,
            label: 'Jogar',
            route: '/games',
          ),
          _NavBarItemWidget(
            item: NavBarItem.info,
            activeItem: activeItem,
            icon: Icons.chat_bubble_outline,
            label: 'Info',
            route: '/info',
          ),
          _NavBarItemWidget(
            item: NavBarItem.profile,
            activeItem: activeItem,
            icon: Icons.face,
            label: 'Perfil',
            route: '/perfil',
          ),
        ],
      ),
    );
  }
}

class _NavBarItemWidget extends StatelessWidget {
  final NavBarItem item;
  final NavBarItem activeItem;
  final IconData icon;
  final String label;
  final String route;

  const _NavBarItemWidget({
    required this.item,
    required this.activeItem,
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = activeItem == item;

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: isActive
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.neonGreen,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGreen.withValues(alpha: 0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.black, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            )
          : Icon(
              icon,
              color: AppColors.textGrey,
              size: 26,
            ),
    );
  }
}
