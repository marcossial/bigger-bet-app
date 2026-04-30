import 'package:bigger_bet/features/onboarding/screens/login_screen.dart';
import 'package:bigger_bet/features/onboarding/screens/register_screen.dart'
    show RegisterScreen;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make status bar transparent to match the dark design
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const BiggerBetApp());
}

class BiggerBetApp extends StatelessWidget {
  const BiggerBetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bigger Bet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: '/onboarding',
        routes: {
          '/onboarding': (_) => const OnboardingScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
        });
  }
}
