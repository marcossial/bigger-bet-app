import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/auth_colors.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const AuthTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.icon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: const TextStyle(
            color: AuthColors.labelGreen,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),

        // Field
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: AuthColors.fieldBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AuthColors.fieldBorder, width: 1),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(widget.icon, color: AuthColors.neonGreen, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: widget.isPassword && _obscure,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  style: const TextStyle(
                    color: AuthColors.textWhite,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: const TextStyle(
                      color: AuthColors.placeholderGrey,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (widget.isPassword) ...[
                GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: AuthColors.placeholderGrey,
                      size: 20,
                    ),
                  ),
                ),
              ] else
                const SizedBox(width: 14),
            ],
          ),
        ),
      ],
    );
  }
}
