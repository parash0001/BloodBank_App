import 'package:bloodbank/features/auth/data/data_source/remote_datasource/login_remote_datasource.dart';
import 'package:bloodbank/features/auth/data/dto/login_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';
class LoginViewModel extends Cubit<LoginState> {
  final LoginRemoteDataSource loginRemoteDataSource;
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  LoginViewModel({required this.loginRemoteDataSource}) : super(LoginInitial());

  Future<void> loginUser(String email, String password, BuildContext context) async {
    emit(LoginLoading());
    try {
      final dto = LoginDto(email: email, password: password);
      final result = await loginRemoteDataSource.login(dto);

      await secureStorage.write(key: 'token', value: result['token']);
      await secureStorage.write(key: 'userId', value: result['user']['id']);
      await secureStorage.write(key: 'name', value: result['user']['name']);
      await secureStorage.write(key: 'email', value: result['user']['email']);
      await secureStorage.write(key: 'fp_email', value: result['user']['email']);
      await secureStorage.write(key: 'role', value: result['user']['role']);
      await secureStorage.write(key: 'password', value: password);
      await secureStorage.write(key: 'fp_password', value: password);


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ ${result["message"]}')),
      );

      emit(LoginSuccess(result));
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      emit(LoginFailure(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Login failed')),
      );
    }
  }

 
}
