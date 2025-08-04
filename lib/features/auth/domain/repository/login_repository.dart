import 'package:bloodbank/core/error/failure.dart';
import 'package:bloodbank/features/auth/data/model/login_api_model.dart';
import 'package:bloodbank/features/auth/domain/entity/login_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ILoginRepository {
  Future<Either<Failure, bool>> checkLogin(LoginEntity login);
  Future<Either<Failure, String>> login(LoginApiModel loginData);
}
