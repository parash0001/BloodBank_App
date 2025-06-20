import 'package:bloodbank/app/constant/hive/hive_table_constant.dart';
import 'package:bloodbank/features/register/domain/entity/register_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

//adapter code for converting hive binary code to dart code
part 'register_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.registerTableId)
class RegisterHiveModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;
  @HiveField(4)
  final String phone;

  RegisterHiveModel({
    String? id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  }) : id = id ?? const Uuid().v4();

  //initial data
  const RegisterHiveModel.initial()
    : id = '',
      name = '',
      email = '',
      password = '',
      phone = '';

  //conversion code like to entity and from entity
  RegisterEntity toEntity() {
    return RegisterEntity(
      id: id,
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }

  factory RegisterHiveModel.fromEntity(RegisterEntity register) {
    return RegisterHiveModel(
      id: register.id,
      name: register.name,
      email: register.email,
      password: register.password,
      phone: register.phone,
    );
  }

  // to entity list
  static List<RegisterEntity> toEntityList(List<RegisterHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  // from entity list
  static List<RegisterHiveModel> fromEntityList(List<RegisterEntity> entities) {
    return entities
        .map((entity) => RegisterHiveModel.fromEntity(entity))
        .toList();
  }

  @override
  List<Object?> get props => [id, name, email, password, phone];
}
