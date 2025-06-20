// import 'package:equatable/equatable.dart';
// import 'package:ghar_sewa/features/login/domain/entity/login_entity.dart';
// import 'package:hive/hive.dart';
// import 'package:uuid/uuid.dart';
// import 'package:ghar_sewa/app/constant/hive/hive_table_constant.dart';
// import 'package:ghar_sewa/features/register/domain/entity/register_entity.dart';

// //adapter code for converting hive binary code to dart code
// part 'login_hive_model.g.dart';

// @HiveType(typeId: HiveTableConstant.loginTableId)
// class LoginHiveModel extends Equatable {
//   @HiveField(0)
//   final String id;
//   @HiveField(1)
//   final String email;
//   @HiveField(2)
//   final String password;

//   LoginHiveModel({
//     String? id,
//     required this.email,
//     required this.password,
//   }) : id = id ?? const Uuid().v4();

// //initial data
// const LoginHiveModel.initial() : id = '', email = '', password = '';

// //conversion code like to entity and from entity
//   LoginEntity toEntity() {
//     return LoginEntity(
//       id: id,
//       email: email,
//       password: password,
//     );
//   }

//   factory LoginHiveModel.fromEntity(LoginEntity login) {
//     return LoginHiveModel(
//       id: login.id,
//       email: login.email,
//       password: login.password,
//     );
//   }

//     // to entity list
//   static List<LoginEntity> toEntityList(List<LoginHiveModel> models) {
//     return models.map((model) => model.toEntity()).toList();
//   }

//     // from entity list
//   static List<LoginHiveModel> fromEntityList(List<LoginEntity> entities) {
//     return entities.map((entity) => LoginHiveModel.fromEntity(entity)).toList();
//   }

//   @override
//   List<Object?> get props => [id, email, password];

// }

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:ghar_sewa/app/constant/hive/hive_table_constant.dart';
import 'package:ghar_sewa/features/login/domain/entity/login_entity.dart';

part 'login_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.loginTableId)
class LoginHiveModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String password;

  LoginHiveModel({String? id, required this.email, required this.password})
    : id = id ?? const Uuid().v4();

  factory LoginHiveModel.fromEntity(LoginEntity entity) {
    return LoginHiveModel(
      id: entity.id,
      email: entity.email,
      password: entity.password,
    );
  }

  @override
  List<Object?> get props => [id, email, password];
}
