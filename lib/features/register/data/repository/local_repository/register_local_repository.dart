import 'package:dartz/dartz.dart';
import 'package:bloodbank/core/error/failure.dart';
import 'package:bloodbank/features/register/data/data_source/local_datasource/register_local_datasource.dart';
import 'package:bloodbank/features/register/data/data_source/register_datasource.dart';
import 'package:bloodbank/features/register/domain/entity/register_entity.dart';
import 'package:bloodbank/features/register/domain/repository/register_repository.dart';

class RegisterLocalRepository implements IRegisterRepository {
  final RegisterLocalDataSource _registerLocalDataSource;

  RegisterLocalRepository({
    required RegisterLocalDataSource registerLocalDataSource,
  }) : _registerLocalDataSource = registerLocalDataSource;

  @override
  Future<Either<Failure, void>> addRegister(RegisterEntity register) async {
    try {
      await _registerLocalDataSource.addRegister(register);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
