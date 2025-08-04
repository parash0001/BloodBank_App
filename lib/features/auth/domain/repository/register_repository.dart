

import 'package:bloodbank/features/auth/data/dto/register_dto.dart';

abstract class IRegisterRepository {
  Future<dynamic> register(RegisterDto dto);
}
