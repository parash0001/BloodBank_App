import 'package:dartz/dartz.dart';
import 'package:ghar_sewa/core/error/failure.dart';
import 'package:ghar_sewa/features/login/domain/entity/login_entity.dart';
import 'package:ghar_sewa/features/login/domain/repository/login_repository.dart';
import 'package:ghar_sewa/app/use_case/usecase.dart';

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
    final login = LoginEntity(
      id: '',
      email: params.email,
      password: params.password,
    );
    return await loginRepository.checkLogin(login);
  }
}
