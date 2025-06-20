import 'package:ghar_sewa/core/error/failure.dart';
import 'package:ghar_sewa/core/network/hive_service.dart';
import 'package:ghar_sewa/features/login/data/model/login_hive_model.dart';

abstract interface class ILoginLocalDataSource {
  Future<bool> checkLogin(LoginHiveModel login);
}

class LoginLocalDataSource implements ILoginLocalDataSource {
  final HiveService hiveService;

  LoginLocalDataSource({required this.hiveService});

  @override
  Future<bool> checkLogin(LoginHiveModel login) async {
    try {
      return await hiveService.checkLogin(login);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }
}
