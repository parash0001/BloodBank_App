part of 'register_view_model.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final dynamic response;

  RegisterSuccess(this.response);
}

class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure(this.error);
}
