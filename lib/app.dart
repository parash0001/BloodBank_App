import 'package:bloodbank/app/service_locator/service_locator.dart'; // 👈 to access serviceLocator
import 'package:bloodbank/bottom_navigation_screen/dashboard_screen.dart';
import 'package:bloodbank/features/login/presentation/view/login_view.dart';
import 'package:bloodbank/features/login/presentation/view_model/login_view_model.dart';
import 'package:bloodbank/features/register/presentation/view/register_view.dart';
import 'package:bloodbank/features/register/presentation/view_model/register_view_model.dart';
import 'package:bloodbank/features/splash/presentation/view/splash_screen.dart';
import 'package:bloodbank/screens/about_us.dart';
import 'package:bloodbank/screens/acheivements_screen.dart';
import 'package:bloodbank/screens/popular_service_screen.dart';
import 'package:bloodbank/screens/service_provider_detail.dart';
import 'package:bloodbank/screens/top_rated.dart';
import 'package:bloodbank/screens/trending_service_screen.dart';
import 'package:bloodbank/theme/app_theme_font.dart';
import 'package:bloodbank/view/login_screen.dart';
import 'package:bloodbank/view/main_navbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BloodBankApp extends StatelessWidget {
  const BloodBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blodd Bank',
      initialRoute: '/',
      // theme: getApplicationTheme(),
      routes: {
        '/': (context) => const SplashScreenView(),
        '/dashboard': (context) => const DashboardScreen(),

        '/register':
            (context) => BlocProvider.value(
              value: serviceLocator<RegisterViewModel>(),
              child: const RegisterView(),
            ),
        '/login':
            (context) => BlocProvider(
              create:
                  (_) => LoginViewModel(checkLoginUsecase: serviceLocator()),
              child: const LoginView(),
            ),
      },
    );
  }
}
