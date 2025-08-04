import 'package:bloodbank/core/error/failure.dart';
import 'package:bloodbank/features/auth/data/model/login_api_model.dart';
import 'package:bloodbank/features/auth/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase {
  final ILoginRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, String>> call(LoginApiModel loginData) {
    return repository.login(loginData);
  }
}
