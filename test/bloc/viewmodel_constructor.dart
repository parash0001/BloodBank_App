import 'package:flutter_test/flutter_test.dart';
import 'package:bloodbank/features/auth/data/data_source/remote_datasource/register_datasource.dart';
import 'package:bloodbank/features/auth/domain/use_case/add_register_usecase.dart';
import 'package:bloodbank/features/auth/presentation/view_model/register_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterDataSource extends Mock implements RegisterDataSource {}
class MockAddRegisterUsecase extends Mock implements AddRegisterUsecase {}

void main() {
  test('RegisterViewModel is constructed properly', () {
    final dataSource = MockRegisterDataSource();
    final usecase = MockAddRegisterUsecase();
    final viewModel = RegisterViewModel(
      registerDataSource: dataSource,
      addRegisterUsecase: usecase,
    );
    expect(viewModel, isA<RegisterViewModel>());
  });
}
