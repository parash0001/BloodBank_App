


sealed class RegisterEvent {}

final class AddRegisterEvent extends RegisterEvent {
    final String name;
    final String email;
    final String password;
    final String phone;
    final String country;
    final String province;

    AddRegisterEvent({
        required this.name,
        required this.email,
        required this.password,
        required this.phone,
        required this.country,
        required this.province,
    });

     
}
    
    
     




