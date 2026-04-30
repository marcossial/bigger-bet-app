import 'package:flutter/material.dart';
import '../../../core/theme/auth_colors.dart';

class NeonActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const NeonActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: AuthColors.neonGreen,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AuthColors.neonGreen.withOpacity(0.45),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
        ),
      ),
    );
  }
}
