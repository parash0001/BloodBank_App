import 'package:bloodbank/features/auth/data/data_source/remote_datasource/register_datasource.dart';
import 'package:bloodbank/features/auth/data/dto/register_dto.dart';
import 'package:bloodbank/features/auth/domain/use_case/add_register_usecase.dart';
import 'package:flutter/material.dart';


class RegisterViewModel {
  final RegisterDataSource registerDataSource;
  final AddRegisterUsecase addRegisterUsecase;

  RegisterViewModel({
    required this.registerDataSource,
    required this.addRegisterUsecase,
  });

 

  Future<void> registerUser(RegisterDto dto, BuildContext context, VoidCallback onSuccess) async {
    try {
      final result = await registerDataSource.register(dto);
      debugPrint("Register success: $result");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ ${result['message']}")),
      );

      onSuccess(); // Clear form
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      debugPrint("Register failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Registration failed")),
      );
    }
  }
}
