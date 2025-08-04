// import 'package:bloodbank/features/auth/data/data_source/remote_datasource/register_datasource.dart';
// import 'package:bloodbank/features/auth/data/dto/register_dto.dart';
// import 'package:bloodbank/features/auth/domain/use_case/add_register_usecase.dart';
// import 'package:bloodbank/features/auth/presentation/view_model/register_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockRegisterDataSource extends Mock implements RegisterDataSource {}
// class MockAddRegisterUsecase extends Mock implements AddRegisterUsecase {}
// class MockBuildContext extends Fake implements BuildContext {}

// void main() {
//   group('RegisterViewModel', () {
//     late RegisterViewModel viewModel;
//     late MockRegisterDataSource mockDataSource;
//     late MockAddRegisterUsecase mockUsecase;

//     setUp(() {
//       mockDataSource = MockRegisterDataSource();
//       mockUsecase = MockAddRegisterUsecase();
//       viewModel = RegisterViewModel(
//         registerDataSource: mockDataSource,
//         addRegisterUsecase: mockUsecase,
//       );
//     });

//     test('registerUser success shows snackbar and triggers onSuccess', () async {
//       final dto = RegisterDto(
//         firstName: 'Test',
//         lastName: 'User',
//         email: 'test@example.com',
//         password: '12345678',
//         phone: '9800000000',
//         age: 25,
//         bloodType: 'A+',
//       );

//       when(() => mockDataSource.register(any())).thenAnswer((_) async => {'message': 'Registered'});

//       bool callbackCalled = false;
//       await viewModel.registerUser(dto, MockBuildContext(), () {
//         callbackCalled = true;
//       });

//       expect(callbackCalled, true);
//       verify(() => mockDataSource.register(dto)).called(1);
//     });

//     test('registerUser failure catches exception and shows snackbar', () async {
//       final dto = RegisterDto(
//         firstName: 'Fail',
//         lastName: 'User',
//         email: 'fail@example.com',
//         password: 'fail1234',
//         phone: '9800000000',
//         age: 22,
//         bloodType: 'O-',
//       );

//       when(() => mockDataSource.register(any())).thenThrow(Exception('API failed'));

//       await viewModel.registerUser(dto, MockBuildContext(), () {});
//       verify(() => mockDataSource.register(dto)).called(1);
//     });
//   });
// }
