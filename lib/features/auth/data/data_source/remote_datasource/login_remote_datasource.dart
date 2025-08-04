import 'package:bloodbank/core/network/api_service.dart';
import 'package:bloodbank/app/constant/api_endpoints.dart';
import 'package:bloodbank/features/auth/data/dto/login_dto.dart';


class LoginRemoteDataSource {
  final ApiService apiService;

  LoginRemoteDataSource({required this.apiService});

  Future<dynamic> login(LoginDto dto) async {
    final response = await apiService.dio.post(ApiEndpoints.login, data: dto.toJson());
    return response.data;
  }
}
