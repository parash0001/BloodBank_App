class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 5000);
  static const receiveTimeout = Duration(seconds: 5000);

  // For Android Emulator
  static const String serverAddress = "http://192.168.101.4:5000";
  // static const String serverAddress = "http://10.0.2.2:3000";
  // static const String serverAddress = "http://192.168.137.1:3000";

  // For iOS Simulator
  // static const String serverAddress = "http://localhost:3000";

  // For iPhone (uncomment if needed)
  static const String baseUrl = "$serverAddress/api/";
  static const String imageUrl = "$baseUrl/uploads/";

  // Auth
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String getAllStudent = "auth/getAllStudents";
  static const String getStudentsByBatch = "auth/getStudentsByBatch/";
  static const String getStudentsByCourse = "auth/getStudentsByCourse/";
  static const String updateStudent = "auth/updateStudent/";
  static const String deleteStudent = "auth/deleteStudent/";
  static const String uploadImage = "auth/uploadImage";

  // Batch
  static const String createBatch = "batch/createBatch";
  static const String getAllBatch = "batch/getAllBatches";
  static const String deleteBatch = "batch/";

  // Course
  static const String createCourse = "course/createCourse";
  static const String deleteCourse = "course/";
  static const String getAllCourse = "course/getAllCourse";
}
