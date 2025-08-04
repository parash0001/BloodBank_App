import 'package:bloodbank/app/service_locator/service_locator.dart';
import 'package:bloodbank/features/auth/presentation/view/login_view.dart';
import 'package:bloodbank/features/auth/presentation/view/signup_view.dart';
import 'package:bloodbank/features/auth/presentation/view_model/login_view_model.dart';
import 'package:bloodbank/features/home/presentation/view/bottom_view/profile_tab.dart';
import 'package:bloodbank/features/home/presentation/view/dashboard_view.dart';
import 'package:bloodbank/features/home/presentation/view/profile/about_us.dart';
import 'package:bloodbank/features/home/presentation/view/profile/account_info.dart';
import 'package:bloodbank/features/home/presentation/view/profile/donation_screen.dart';
import 'package:bloodbank/features/home/presentation/view/profile/edit_profile_screen.dart';
import 'package:bloodbank/features/home/presentation/view/profile/feedback_history.dart';
import 'package:bloodbank/features/home/presentation/view/profile/feedback_screen.dart';
import 'package:bloodbank/features/home/presentation/view/profile/privacy_policy.dart';
import 'package:bloodbank/features/home/presentation/view/profile/register_fingerprint.dart';
import 'package:bloodbank/features/home/presentation/view/profile/terms_screen.dart';
import 'package:bloodbank/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart'; // Import to access navigatorKey and messengerKey

class BloodBankApp extends StatelessWidget {
  const BloodBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<LoginViewModel>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blood Bank',
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: messengerKey,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginView(),
          '/register': (context) => const SignupView(),
          '/dashboard': (context) => const DashboardView(),
          '/profile': (context) => const ProfileScreen(),
          '/editProfile': (context) => const EditProfileScreen(),
          '/accountInfo': (context) => const AccountInfoScreen(),
          '/aboutUs': (context) => const AboutUsScreen(),
          '/privacyPolicy': (context) => const PrivacyPolicyScreen(),
          '/terms': (context) => const TermsScreen(),
          '/donationHistory': (context) => const DonationHistoryPage(),
          '/feedback': (context) => const FeedbackScreen(),
          '/feedbackHistory': (context) => const FeedbackHistoryScreen(),
          '/registerFingerprint': (context) => const RegisterFingerprintScreen(),
        },
      ),
    );
  }
}
