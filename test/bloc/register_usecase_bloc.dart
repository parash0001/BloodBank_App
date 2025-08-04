import 'package:flutter_test/flutter_test.dart';
import 'package:bloodbank/features/auth/data/dto/register_dto.dart';
import 'package:bloodbank/features/auth/domain/repository/register_repository.dart';
import 'package:bloodbank/features/auth/domain/use_case/add_register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterRepository extends Mock implements IRegisterRepository {}

void main() {
  group('AddRegisterUsecase', () {
    late MockRegisterRepository mockRepo;
    late AddRegisterUsecase usecase;

    setUp(() {
      mockRepo = MockRegisterRepository();
      usecase = AddRegisterUsecase(mockRepo);
    });

    test('calls repository.register and returns response', () async {
      final dto = RegisterDto(
        firstName: 'Test User',
        lastName: 'Example',
        email: 'test@example.com',
        password: '12345678',
        phone: '9800000000',
        age: 30,
        bloodType: 'B+',
      );

      when(() => mockRepo.register(dto)).thenAnswer((_) async => {'message': 'Registered'});

      final result = await usecase(dto);
      expect(result, {'message': 'Registered'});
      verify(() => mockRepo.register(dto)).called(1);
    });
  });
}