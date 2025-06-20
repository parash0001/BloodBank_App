import 'package:get_it/get_it.dart';
import 'package:bloodbank/core/network/hive_service.dart';
import 'package:bloodbank/features/login/data/data_source/local_datasource/login_local_datasource.dart';
import 'package:bloodbank/features/login/data/repository/local_repository/login_local_repository.dart';
import 'package:bloodbank/features/login/domain/use_case/check_login_usecase.dart';
import 'package:bloodbank/features/login/presentation/view_model/login_view_model.dart';
import 'package:bloodbank/features/register/data/data_source/local_datasource/register_local_datasource.dart';
import 'package:bloodbank/features/register/data/repository/local_repository/register_local_repository.dart';
import 'package:bloodbank/features/register/domain/use_case/add_register_usecase.dart';
import 'package:bloodbank/features/register/presentation/view_model/register_view_model.dart';
// 1 min hai parkha 
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initRegisterModule();
  await _initLoginModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

// register module

Future<void> _initRegisterModule() async {
  serviceLocator.registerFactory(
    () => RegisterLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  // Register the repository
  serviceLocator.registerFactory(
    () => RegisterLocalRepository(
      registerLocalDataSource: serviceLocator<RegisterLocalDataSource>(),
    ),
  );

  //usecases
  serviceLocator.registerFactory(
    () => AddRegisterUsecase(
      registerRepository: serviceLocator<RegisterLocalRepository>(),
    ),
  );

  //viw model

  serviceLocator.registerLazySingleton(
    () => RegisterViewModel(
      addRegisterUsecase: serviceLocator<AddRegisterUsecase>(),
    ),
  );
}

Future<void> _initLoginModule() async {
  serviceLocator.registerFactory(
    () => LoginLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => LoginLocalRepository(
      loginLocalDataSource: serviceLocator<LoginLocalDataSource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => CheckLoginUsecase(
      loginRepository: serviceLocator<LoginLocalRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () =>
        LoginViewModel(checkLoginUsecase: serviceLocator<CheckLoginUsecase>()),
  );
}
