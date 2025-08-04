
import 'package:bloodbank/features/auth/data/data_source/remote_datasource/register_datasource.dart';
import 'package:bloodbank/features/auth/data/dto/register_dto.dart';
import 'package:bloodbank/features/auth/domain/repository/register_repository.dart';

class RegisterRepository implements IRegisterRepository {
  final RegisterDataSource registerDataSource;

  RegisterRepository({required this.registerDataSource});

  @override
  Future<dynamic> register(RegisterDto dto) {
    return registerDataSource.register(dto);
  }
}
