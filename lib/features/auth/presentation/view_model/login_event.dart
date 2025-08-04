sealed class LoginEvent {}

final class CheckLoginEvent extends LoginEvent {
  final String email;
  final String password;

  CheckLoginEvent({required this.email, required this.password});
}
