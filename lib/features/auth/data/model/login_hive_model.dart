

import 'package:bloodbank/app/constant/hive/hive_table_constant.dart';
import 'package:bloodbank/features/auth/domain/entity/login_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'login_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.loginTableId)
class LoginHiveModel extends Equatable {
  
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String password;

  const LoginHiveModel({required this.email, required this.password});

  factory LoginHiveModel.fromEntity(LoginEntity entity) {
    return LoginHiveModel(
      email: entity.email,
      password: entity.password,
    );
  }

  @override
  List<Object?> get props => [email, password];
}
