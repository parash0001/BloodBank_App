// import 'package:bloc_test/bloc_test.dart';
// import 'package:bloodbank/features/auth/data/data_source/remote_datasource/login_remote_datasource.dart';
// import 'package:bloodbank/features/auth/presentation/view_model/login_view_model.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:flutter_test/flutter_test.dart';

// class MockLoginRemoteDataSource extends Mock implements LoginRemoteDataSource {}
// class MockSecureStorage extends Mock implements FlutterSecureStorage {}
// class MockBuildContext extends Fake implements BuildContext {}

// void main() {
//   setUpAll(() {
//     registerFallbackValue(MockBuildContext());
//   });

//   group('LoginViewModel', () {
//     late MockLoginRemoteDataSource mockRemote;
//     late MockSecureStorage mockStorage;
//     late LoginViewModel viewModel;

//     setUp(() {
//       mockRemote = MockLoginRemoteDataSource();
//       mockStorage = MockSecureStorage();
//       viewModel = LoginViewModel(loginRemoteDataSource: mockRemote);
//       viewModel.secureStorage = mockStorage;
//     });

//     blocTest<LoginViewModel, LoginState>(
//       'emits [LoginLoading, LoginSuccess] when login is successful',
//       build: () {
//         when(() => mockRemote.login(any())).thenAnswer((_) async => {
//               'token': 'abc123',
//               'message': 'Logged in successfully',
//               'user': {
//                 'id': '1',
//                 'name': 'Test',
//                 'email': 'test@example.com',
//                 'role': 'user'
//               }
//             });
//         when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
//             .thenAnswer((_) async {});
//         return viewModel;
//       },
//       act: (bloc) => bloc.loginUser('test@example.com', 'password', MockBuildContext()),
//       expect: () => [isA<LoginLoading>(), isA<LoginSuccess>()],
//     );

//     blocTest<LoginViewModel, LoginState>(
//       'emits [LoginLoading, LoginFailure] when login fails',
//       build: () {
//         when(() => mockRemote.login(any())).thenThrow(Exception('Failed'));
//         return viewModel;
//       },
//       act: (bloc) => bloc.loginUser('wrong@example.com', 'badpass', MockBuildContext()),
//       expect: () => [isA<LoginLoading>(), isA<LoginFailure>()],
//     );
//   });
// }
