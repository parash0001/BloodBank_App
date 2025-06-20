import 'package:bloodbank/core/error/failure.dart';
import 'package:bloodbank/core/network/hive_service.dart';
import 'package:bloodbank/features/register/data/data_source/register_datasource.dart';
import 'package:bloodbank/features/register/data/model/register_hive_model.dart';
import 'package:bloodbank/features/register/domain/entity/register_entity.dart';

class RegisterLocalDataSource implements IRegisterLocalDataSource {
  final HiveService _hiveService;
  //dependency injection
  RegisterLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> addRegister(RegisterEntity register) async {
    try {
      final registerHiveModel = RegisterHiveModel.fromEntity(register);
      await _hiveService.addRegister(registerHiveModel);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }
}
