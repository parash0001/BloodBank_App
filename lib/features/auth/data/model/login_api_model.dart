import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_api_model.g.dart';

@JsonSerializable()
class LoginApiModel extends Equatable {
  final String email;
  final String password;

  const LoginApiModel({required this.email, required this.password});

  factory LoginApiModel.fromJson(Map<String, dynamic> json) =>
      _$LoginApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginApiModelToJson(this);

  @override
  List<Object?> get props => [email, password];
}
