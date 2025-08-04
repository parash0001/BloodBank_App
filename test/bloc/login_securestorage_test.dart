import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('SecureStorage Login', () {
    late MockSecureStorage mockStorage;

    setUp(() {
      mockStorage = MockSecureStorage();
    });

    test('writes login data correctly', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await mockStorage.write(key: 'email', value: 'test@example.com');
      await mockStorage.write(key: 'token', value: 'abc123');

      verify(() => mockStorage.write(key: 'email', value: 'test@example.com')).called(1);
      verify(() => mockStorage.write(key: 'token', value: 'abc123')).called(1);
    });

    test('reads login data correctly', () async {
      when(() => mockStorage.read(key: 'email')).thenAnswer((_) async => 'test@example.com');
      final email = await mockStorage.read(key: 'email');
      expect(email, 'test@example.com');
    });

    test('deletes login data correctly', () async {
      when(() => mockStorage.delete(key: any(named: 'key'))).thenAnswer((_) async {});
      await mockStorage.delete(key: 'token');
      verify(() => mockStorage.delete(key: 'token')).called(1);
    });
  });
}
