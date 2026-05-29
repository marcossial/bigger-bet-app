import 'package:bigger_bet/features/games/screens/games_screen.dart';
import 'package:bigger_bet/features/home/screens/home_screen.dart';
import 'package:bigger_bet/features/info/screens/info_screen.dart';
import 'package:bigger_bet/features/auth/screens/login_screen.dart';
import 'package:bigger_bet/features/auth/screens/register_screen.dart'
    show RegisterScreen;
import 'package:bigger_bet/features/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/onboarding': (_) => const OnboardingScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const BiggerBetHome(),
          '/games': (_) => const GamesScreen(),
          '/info': (_) => const InfoScreen(),
          // '/perfil': (_) => const PerfilScreen(),
          ...GamesScreen.routes,
        });
  }
}
