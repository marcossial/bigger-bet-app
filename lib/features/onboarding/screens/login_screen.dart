import 'package:flutter/material.dart';
import '../widgets/alien_avatar_card.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/neon_action_button.dart';
import '../widgets/terms_checkbox.dart';
import '../widgets/welcome_badge.dart';
import '../../../core/theme/auth_colors.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginScreen({super.key, this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _termsAccepted = false;
  bool _isLoading = false;

  void _handleLogin() async {
    if (!_termsAccepted) {
      _showSnack('Aceite os termos para continuar.');
      return;
    }
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnack('Preencha e-mail e senha.');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // simulate request
    setState(() => _isLoading = false);

    Navigator.pushReplacementNamed(context, '/home');
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

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // ── Alien avatar ──────────────────────────────────────────────
              const AlienAvatarCard(),
              const SizedBox(height: 16),

              // ── Welcome badge ─────────────────────────────────────────────
              const WelcomeBadge(),
              const SizedBox(height: 40),

              // ── E-mail ────────────────────────────────────────────────────
              AuthTextField(
                label: 'E-MAIL',
                placeholder: 'seu@cosmos.com',
                icon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
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
              const SizedBox(height: 28),

              // ── Terms ─────────────────────────────────────────────────────
              TermsCheckbox(
                onChanged: (v) => setState(() => _termsAccepted = v),
              ),
              const SizedBox(height: 36),

              // ── Login button ──────────────────────────────────────────────
              NeonActionButton(
                label: 'ENTRAR →',
                onPressed: _handleLogin,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 28),

              // ── Register link ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Não tem conta? ',
                    style: TextStyle(
                      color: AuthColors.placeholderGrey,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: _goToRegister,
                    child: const Text(
                      'Cadastre-se',
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
