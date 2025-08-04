class RegisterDto {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final int age;
  final String bloodType;

  RegisterDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.age,
    required this.bloodType,
  });

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "phone": phone,
        "age": age,
        "bloodType": bloodType,
      };
}
