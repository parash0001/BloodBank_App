abstract class Failure {
  final String message;

  const Failure({required this.message});
}

class LocalDatabaseFailure extends Failure {
  LocalDatabaseFailure({required super.message});
}

class RemoteDatabaseFailure extends Failure {
  final int statusCode;
  RemoteDatabaseFailure({required this.statusCode, required super.message});
}

class SharedPreferencesFailure extends Failure {
  SharedPreferencesFailure({required super.message});
}
