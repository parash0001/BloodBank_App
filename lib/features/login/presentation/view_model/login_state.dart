import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String? errorMessage;
  final bool? loginMatched;

  const LoginState({
    required this.isLoading,
    required this.isSuccess,
    required this.isFailure,
    required this.errorMessage,
    this.loginMatched,
  });

  LoginState.initial()
    : isLoading = false,
      isSuccess = false,
      isFailure = false,
      errorMessage = null,
      loginMatched = null;

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
    bool? loginMatched,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage ?? this.errorMessage,
      loginMatched: loginMatched ?? this.loginMatched,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    isFailure,
    errorMessage,
    loginMatched,
  ];
}
