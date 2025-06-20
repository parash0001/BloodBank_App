import 'package:dartz/dartz.dart';
import 'package:bloodbank/core/error/failure.dart';
import 'package:bloodbank/features/register/domain/entity/register_entity.dart';

abstract interface class IRegisterRepository {
    Future<Either<Failure, void>> addRegister(RegisterEntity register);
}