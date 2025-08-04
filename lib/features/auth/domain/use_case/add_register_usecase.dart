
import 'package:bloodbank/features/auth/data/dto/register_dto.dart';
import 'package:bloodbank/features/auth/domain/repository/register_repository.dart';



class AddRegisterUsecase {
  final IRegisterRepository repository;

  AddRegisterUsecase(this.repository);

  Future<dynamic> call(RegisterDto dto) {
    return repository.register(dto);
  }
}
