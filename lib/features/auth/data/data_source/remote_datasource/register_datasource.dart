import 'package:bloodbank/core/network/api_service.dart';
import 'package:bloodbank/app/constant/api_endpoints.dart';
import 'package:bloodbank/features/auth/data/dto/register_dto.dart';


class RegisterDataSource {
  final ApiService apiService;

  RegisterDataSource({required this.apiService});

  Future<dynamic> register(RegisterDto dto) async {
    final response = await apiService.dio.post(ApiEndpoints.register, data: dto.toJson());
    return response.data;
  }
}
