import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;

  const RegisterEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  List<Object?> get props => [name, email, password, phone];
}
