import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/alien_avatar_card.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/neon_action_button.dart';
import '../widgets/terms_checkbox.dart';
import '../widgets/welcome_badge.dart';
import '../../../core/theme/auth_colors.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onRegisterSuccess;

  const RegisterScreen({super.key, this.onRegisterSuccess});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cpfController = TextEditingController();
  bool _termsAccepted = false;
  bool _isLoading = false;

  void _handleRegister() async {
    if (!_termsAccepted) {
      _showSnack('Aceite os termos para continuar.');
      return;
    }
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _cpfController.text.isEmpty) {
      _showSnack('Preencha todos os campos.');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnack('As senhas não coincidem.');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // simulate request
    setState(() => _isLoading = false);

    widget.onRegisterSuccess?.call();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF1A1D2E),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.background,
      // Back arrow
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // ── Alien avatar ──────────────────────────────────────────────
              const AlienAvatarCard(),
              const SizedBox(height: 16),

              // ── Badge ─────────────────────────────────────────────────────
              const WelcomeBadge(text: 'CRIE SUA CONTA'),
              const SizedBox(height: 36),

              // ── Nome ──────────────────────────────────────────────────────
              AuthTextField(
                label: 'NOME',
                placeholder: 'Seu nome completo',
                icon: Icons.person_outline,
                controller: _nameController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 20),

              // ── E-mail ────────────────────────────────────────────────────
              AuthTextField(
                label: 'E-MAIL',
                placeholder: 'seu@cosmos.com',
                icon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // ── CPF ───────────────────────────────────────────────────────
              AuthTextField(
                label: 'CPF',
                placeholder: '000.000.000-00',
                icon: Icons.fingerprint,
                controller: _cpfController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _CpfInputFormatter(),
                ],
              ),
              const SizedBox(height: 20),

              // ── Senha ─────────────────────────────────────────────────────
              AuthTextField(
                label: 'SENHA',
                placeholder: '••••••••',
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 20),

              // ── Confirmar senha ───────────────────────────────────────────
              AuthTextField(
                label: 'CONFIRMAR SENHA',
                placeholder: '••••••••',
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 28),

              // ── Terms ─────────────────────────────────────────────────────
              TermsCheckbox(
                onChanged: (v) => setState(() => _termsAccepted = v),
              ),
              const SizedBox(height: 36),

              // ── Register button ───────────────────────────────────────────
              NeonActionButton(
                label: 'CADASTRAR →',
                onPressed: _handleRegister,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 28),

              // ── Login link ────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Já tem conta? ',
                    style: TextStyle(
                      color: AuthColors.placeholderGrey,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Fazer login',
                      style: TextStyle(
                        color: AuthColors.neonGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: AuthColors.neonGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── CPF formatter: 000.000.000-00 ───────────────────────────────────────────
class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length && i < 11; i++) {
      if (i == 3 || i == 6) buffer.write('.');
      if (i == 9) buffer.write('-');
      buffer.write(digits[i]);
    }

    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
