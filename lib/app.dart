import 'package:bloodbank/bottom_navigation_screen/dashboard_screen.dart';
import 'package:bloodbank/theme/theme_data.dart';
import 'package:bloodbank/view/login_screen.dart';
import 'package:bloodbank/view/signup_screen.dart';
import 'package:bloodbank/view/splash_screen.dart';
import 'package:flutter/material.dart';

class BloodBankApp extends StatelessWidget {
  const BloodBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BloodBank',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(), // ✅ Apply centralized theme with fonts
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
