// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginApiModel _$LoginApiModelFromJson(Map<String, dynamic> json) =>
    LoginApiModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginApiModelToJson(LoginApiModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };
