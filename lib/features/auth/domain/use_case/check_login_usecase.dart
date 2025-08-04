import 'package:bloodbank/app/use_case/usecase.dart';
import 'package:bloodbank/core/error/failure.dart';
import 'package:bloodbank/features/auth/domain/entity/login_entity.dart';
import 'package:bloodbank/features/auth/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';

class CheckLoginParams {
  final String email;
  final String password;

  CheckLoginParams({required this.email, required this.password});
}

class CheckLoginUsecase implements UsecaseWithParams<bool, CheckLoginParams> {
  final ILoginRepository loginRepository;

  CheckLoginUsecase({required this.loginRepository});

  @override
  Future<Either<Failure, bool>> call(CheckLoginParams params) async {
    final login = LoginEntity(email: params.email, password: params.password);
    return await loginRepository.checkLogin(login);
  }
}
