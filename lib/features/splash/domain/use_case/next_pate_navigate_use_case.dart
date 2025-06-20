// path: features/splash/domain/use_case/next_pate_navigate_use_case.dart

import 'dart:async';

import 'package:bloodbank/app/service_locator/service_locator.dart';
import 'package:bloodbank/core/network/hive_service.dart';

class NextPageNavigateUseCase {
  Future<void> waitAndNavigate(Function(String route) navigateCallback) async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    final hiveService = serviceLocator<HiveService>();
    final loggedInEmail = await hiveService.getLoggedInUserEmail();

    if (loggedInEmail != null && loggedInEmail.isNotEmpty) {
      navigateCallback('/home');
    } else {
      navigateCallback('/login');
    }
  }
}
