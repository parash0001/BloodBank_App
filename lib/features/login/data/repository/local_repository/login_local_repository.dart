import 'package:dartz/dartz.dart';
import 'package:ghar_sewa/core/error/failure.dart';
import 'package:ghar_sewa/features/login/data/data_source/local_datasource/login_local_datasource.dart';
import 'package:ghar_sewa/features/login/domain/entity/login_entity.dart';
import 'package:ghar_sewa/features/login/domain/repository/login_repository.dart';
import 'package:ghar_sewa/features/login/data/model/login_hive_model.dart';

class LoginLocalRepository implements ILoginRepository {
  final ILoginLocalDataSource loginLocalDataSource;

  LoginLocalRepository({required this.loginLocalDataSource});

  @override
  Future<Either<Failure, bool>> checkLogin(LoginEntity login) async {
    try {
      final model = LoginHiveModel.fromEntity(login);
      final isValid = await loginLocalDataSource.checkLogin(model);
      return Right(isValid);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
