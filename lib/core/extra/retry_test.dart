// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bloodbank/features/auth/data/data_source/remote_datasource/login_remote_datasource.dart';
// import 'package:bloodbank/features/auth/presentation/view_model/login_view_model.dart';

// import 'package:mocktail/mocktail.dart';
// import 'package:flutter/material.dart';

// class MockLoginRemoteDataSource extends Mock implements LoginRemoteDataSource {}
// class MockBuildContext extends Fake implements BuildContext {}

// void main() {
//   setUpAll(() {
//     registerFallbackValue(MockBuildContext());
//   });

//   group('Login Retry Mechanism', () {
//     late MockLoginRemoteDataSource mockRemote;
//     late LoginViewModel viewModel;

//     setUp(() {
//       mockRemote = MockLoginRemoteDataSource();
//       viewModel = LoginViewModel(loginRemoteDataSource: mockRemote);
//     });

//     test('Retries login after failure', () async {
//       // First call throws an exception
//       when(() => mockRemote.login(any()))
//           .thenThrow(Exception('Error'));

//       await viewModel.loginUser('retry@email.com', 'retryPass', MockBuildContext());
//       expect(viewModel.state, isA<LoginFailure>());

//       // Reset mock and mock success on second call
//       reset(mockRemote);
//       when(() => mockRemote.login(any())).thenAnswer((_) async => {
//             'token': 'retry-token',
//             'user': {
//               'id': 'id1',
//               'name': 'Retry',
//               'email': 'retry@email.com',
//               'role': 'user'
//             },
//             'message': 'Success'
//           });

//       await viewModel.loginUser('retry@email.com', 'retryPass', MockBuildContext());
//       expect(viewModel.state, isA<LoginSuccess>());
//     });
//   });
// }
