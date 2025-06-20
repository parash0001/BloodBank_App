import 'package:bloodbank/app/constant/hive/hive_table_constant.dart';
import 'package:bloodbank/features/login/data/model/login_hive_model.dart';
import 'package:bloodbank/features/register/data/model/register_hive_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}ghar_sewa.db';

    Hive.init(path);

    Hive.registerAdapter(RegisterHiveModelAdapter());
    Hive.registerAdapter(LoginHiveModelAdapter());
    //queries
    // Future<void> addRegister(RegisterEntity register) async {
    //   var box = await Hive.openBox(HiveTableConstant.registerBox);
    //   await box.add(register);

    // }
  }

  Future<void> addRegister(RegisterHiveModel register) async {
    // Implement logic to add the register to Hive box
    final box = await Hive.openBox<RegisterHiveModel>(
      HiveTableConstant.registerBox,
    );
    await box.add(register);
  }

  // Future<bool> checkLogin(LoginHiveModel login) async {
  //   final box = await Hive.openBox<LoginHiveModel>(
  //     HiveTableConstant.loginBox,
  //   );

  //   // Get all stored login records
  //   final allLogins = box.values.toList();

  //   // Check if any stored login matches the provided email and password
  //   return allLogins.any((storedLogin) =>
  //     storedLogin.email == login.email &&
  //     storedLogin.password == login.password
  //   );
  // }

  Future<bool> checkLogin(LoginHiveModel login) async {
    final box = await Hive.openBox<RegisterHiveModel>(
      HiveTableConstant.registerBox,
    );

    return box.values.any(
      (stored) =>
          stored.email == login.email && stored.password == login.password,
    );
  }

  Future<void> saveLoggedInUserEmail(String email) async {
    final box = await Hive.openBox('authBox');
    await box.put('loggedInEmail', email);
  }

  Future<String?> getLoggedInUserEmail() async {
    final box = await Hive.openBox('authBox');
    return box.get('loggedInEmail');
  }

  Future<void> logoutUser() async {
    final box = await Hive.openBox('authBox');
    await box.delete('loggedInEmail');
  }
}
