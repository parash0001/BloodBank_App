

import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String? errorMessage;

  RegisterState({
    required this.isLoading,
    required this.isSuccess,
    required this.isFailure,
    required this.errorMessage,
  });

  //initial constructor
  RegisterState.initial() : isLoading = false, isSuccess = false, isFailure = false, errorMessage = null;

  //copy State
  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, isFailure, errorMessage];
    
}