import 'package:bloodbank/features/register/domain/entity/register_entity.dart';

abstract interface class IRegisterLocalDataSource {
  Future<void> addRegister(RegisterEntity register);
}
