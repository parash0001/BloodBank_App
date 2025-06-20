// path: features/splash/presentation/view_model/splash_view_model.dart

import 'package:flutter/material.dart';
import 'package:bloodbank/features/splash/domain/use_case/next_pate_navigate_use_case.dart';

class SplashViewModel extends ChangeNotifier {
  final NextPageNavigateUseCase useCase;

  SplashViewModel(this.useCase);

  void navigateToNextScreen(BuildContext context) {
    useCase.waitAndNavigate((route) {
      Navigator.pushReplacementNamed(context, route);
    });
  }
}
