import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'package:bloodbank/core/network/api_service.dart';

// Login
import 'package:bloodbank/features/auth/data/data_source/remote_datasource/login_remote_datasource.dart';
import 'package:bloodbank/features/auth/presentation/view_model/login_view_model.dart';

// Register
import 'package:bloodbank/features/auth/data/data_source/remote_datasource/register_datasource.dart';
import 'package:bloodbank/features/auth/data/repository/register_repository.dart';
import 'package:bloodbank/features/auth/domain/repository/register_repository.dart';
import 'package:bloodbank/features/auth/domain/use_case/add_register_usecase.dart';
import 'package:bloodbank/features/auth/presentation/view_model/register_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // ✅ API Service
  serviceLocator.registerLazySingleton(() => ApiService(Dio()));

  // ✅ Login Feature
  serviceLocator.registerLazySingleton(() => LoginRemoteDataSource(apiService: serviceLocator()));
  serviceLocator.registerFactory(() => LoginViewModel(
        loginRemoteDataSource: serviceLocator(),
      ));

  // ✅ Register Feature
  serviceLocator.registerLazySingleton(() => RegisterDataSource(apiService: serviceLocator()));
  serviceLocator.registerFactory<IRegisterRepository>(
    () => RegisterRepository(registerDataSource: serviceLocator()),
  );
  serviceLocator.registerFactory(() => AddRegisterUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => RegisterViewModel(
        registerDataSource: serviceLocator(),
        addRegisterUsecase: serviceLocator(),
      ));
}
