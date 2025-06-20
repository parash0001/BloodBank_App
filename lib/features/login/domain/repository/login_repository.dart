import 'package:dartz/dartz.dart';
import 'package:ghar_sewa/core/error/failure.dart';
import 'package:ghar_sewa/features/login/domain/entity/login_entity.dart';

abstract interface class ILoginRepository {
  Future<Either<Failure, bool>> checkLogin(LoginEntity login);
}
