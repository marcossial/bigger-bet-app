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
      home: OnboardingScreen(
        onFinished: () {
          // TODO: Navigate to Login/Register screen
          debugPrint('Onboarding finished → navigate to login');
        },
      ),
    );
  }
}
