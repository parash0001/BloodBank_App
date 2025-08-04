import 'package:bloodbank/features/auth/presentation/view_model/login_view_model.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('LoginState fallback cases', () {
    test('LoginSuccess returns correct response map', () {
      final response = {'message': 'Logged in'};
      final state = LoginSuccess(response);
      expect(state.response['message'], 'Logged in');
    });

    test('LoginFailure stores message', () {
      final state = LoginFailure('Something went wrong');
      expect(state.message, contains('Something'));
    });

    test('LoginInitial is a type of LoginState', () {
      final state = LoginInitial();
      expect(state, isA<LoginState>());
    });

    test('LoginLoading is a type of LoginState', () {
      final state = LoginLoading();
      expect(state, isA<LoginState>());
    });
  });
}
