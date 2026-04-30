import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/theme/auth_colors.dart';

class TermsCheckbox extends StatefulWidget {
  final ValueChanged<bool>? onChanged;

  const TermsCheckbox({super.key, this.onChanged});

  @override
  State<TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() => _checked = !_checked);
            widget.onChanged?.call(_checked);
          },
          child: Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: _checked ? AuthColors.neonGreen : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color:
                    _checked ? AuthColors.neonGreen : const Color(0xFF4A4D5E),
                width: 2,
              ),
            ),
            child: _checked
                ? const Icon(Icons.check, color: Colors.black, size: 14)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: AuthColors.placeholderGrey,
                fontSize: 13,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: 'Aceito os '),
                TextSpan(
                  text: 'Termos de Serviço',
                  style: const TextStyle(
                    color: AuthColors.linkGreen,
                    decoration: TextDecoration.underline,
                    decorationColor: AuthColors.linkGreen,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // TODO: Open Terms of Service
                    },
                ),
                const TextSpan(text: ' e prometo não chorar se perder.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
