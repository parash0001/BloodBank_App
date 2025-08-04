import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'unit_tests.mocks.dart';
import 'package:dio/dio.dart';
import 'package:bloodbank/features/auth/domain/use_case/add_register_usecase.dart';
import 'package:bloodbank/features/auth/domain/repository/register_repository.dart';
import 'package:bloodbank/features/auth/data/model/login_hive_model.dart';
import 'package:bloodbank/features/auth/data/model/login_api_model.dart';
import 'package:bloodbank/features/auth/data/dto/register_dto.dart';
import 'package:bloodbank/core/network/api_service.dart';
import 'package:bloodbank/core/error/failure.dart';



@GenerateMocks([IRegisterRepository])
void main() {
  group('AddRegisterUseCase Test', () {
    test('Should forward registration to repository', () async {
    final mockRepo = MockIRegisterRepository();
    final useCase = AddRegisterUsecase(mockRepo);

    final dto = RegisterDto(
      firstName: 'Test',
      lastName: 'User',
      email: 'test@test.com',
      password: '1234',
      phone: '9800000000',
      age: 25,
      bloodType: 'A+',
    );

  
    when(mockRepo.register(any)).thenAnswer((_) async => true);



    final result = await useCase.call(dto);
    expect(result, true);

    // Optional: confirm it was called with actual DTO
    verify(mockRepo.register(dto)).called(1);
  });
  });

  group('Failure Class Tests', () {
    test('LocalDatabaseFailure returns correct message', () {
      final failure = LocalDatabaseFailure(message: 'Local DB error');
      expect(failure.message, 'Local DB error');
    });

    test('RemoteDatabaseFailure returns message and status code', () {
      final failure = RemoteDatabaseFailure(
        message: 'Server error',
        statusCode: 500,
      );
      expect(failure.message, 'Server error');
      expect(failure.statusCode, 500);
    });

    test('SharedPreferencesFailure returns correct message', () {
      final failure = SharedPreferencesFailure(message: 'Prefs error');
      expect(failure.message, 'Prefs error');
    });
  });

  group('LoginHiveModel Tests', () {
    test('should store email and password properly', () {
      const model = LoginHiveModel(email: 'test@email.com', password: '1234');
      expect(model.email, 'test@email.com');
      expect(model.password, '1234');
    });

    test('equality should work with same values', () {
      const model1 = LoginHiveModel(email: 'test@email.com', password: '1234');
      const model2 = LoginHiveModel(email: 'test@email.com', password: '1234');
      expect(model1, equals(model2));
    });
  });

  group('LoginApiModel Tests', () {
    test('should convert from JSON correctly', () {
      final json = {'email': 'test@email.com', 'password': '1234'};

      final model = LoginApiModel.fromJson(json);
      expect(model.email, 'test@email.com');
      expect(model.password, '1234');
    });

    test('should convert to JSON correctly', () {
      const model = LoginApiModel(email: 'test@email.com', password: '1234');
      final json = model.toJson();
      expect(json['email'], 'test@email.com');
      expect(json['password'], '1234');
    });

    test('equality should work with same values', () {
      const model1 = LoginApiModel(email: 'a@a.com', password: 'pass');
      const model2 = LoginApiModel(email: 'a@a.com', password: 'pass');
      expect(model1, equals(model2));
    });
  });

  group('RegisterDTO Test', () {
    test('Should serialize to JSON correctly', () {
      final dto = RegisterDto(
        firstName: 'Test',
        lastName: 'User',
        email: 'test@test.com',
        password: '1234',
        phone: '1234567890',
        age: 30,
        bloodType: 'O+',
      );
      final json = dto.toJson();
      expect(json['firstName'], 'Test');
      expect(json['lastName'], 'User');
      expect(json['email'], 'test@test.com');
      expect(json['bloodType'], 'O+');
    });
  });

  group('ApiService Headers', () {
    test('Should contain Content-Type application/json', () {
      final dio = Dio(); 
      final apiService = ApiService(dio);

      final headers = apiService.dio.options.headers;

      expect(headers['Content-Type'], 'application/json');
      expect(headers['Accept'], 'application/json');
    });
  });
}
