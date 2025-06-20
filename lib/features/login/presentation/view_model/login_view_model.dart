import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghar_sewa/features/login/domain/use_case/check_login_usecase.dart';
import 'package:ghar_sewa/features/login/presentation/view_model/login_event.dart';
import 'package:ghar_sewa/features/login/presentation/view_model/login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final CheckLoginUsecase checkLoginUsecase;

  LoginViewModel({required this.checkLoginUsecase})
    : super(LoginState.initial()) {
    on<CheckLoginEvent>(_onCheckLogin);
  }

  Future<void> _onCheckLogin(
    CheckLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await checkLoginUsecase(
      CheckLoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          isFailure: true,
          errorMessage: failure.message,
        ),
      ),
      (isMatched) => emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          loginMatched: isMatched,
        ),
      ),
    );
  }
}
