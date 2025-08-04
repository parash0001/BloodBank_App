import 'package:bloodbank/app/service_locator/service_locator.dart';
import 'package:bloodbank/features/auth/data/dto/register_dto.dart';
import 'package:bloodbank/features/auth/presentation/view_model/register_view_model.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final passwordController = TextEditingController();

  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String? _selectedBloodType;

  final viewModel = serviceLocator<RegisterViewModel>();

  void _register() {
  if (!_formKey.currentState!.validate()) return;

  final dto = RegisterDto(
    firstName: firstNameController.text.trim(),
    lastName: lastNameController.text.trim(),
    email: emailController.text.trim(),
    phone: phoneController.text.trim(),
    password: passwordController.text.trim(),
    age: int.parse(ageController.text.trim()),
    bloodType: _selectedBloodType!,
  );

  viewModel.registerUser(dto, context, () {
    // Clear form fields
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    ageController.clear();
    passwordController.clear();
    setState(() => _selectedBloodType = null);
  });
}

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ageController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text('Sign Up', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(controller: firstNameController, decoration: const InputDecoration(labelText: 'First Name')),
                      const SizedBox(height: 12),
                      TextFormField(controller: lastNameController, decoration: const InputDecoration(labelText: 'Last Name')),
                      const SizedBox(height: 12),
                      TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                      const SizedBox(height: 12),
                      TextFormField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
                      const SizedBox(height: 12),
                      TextFormField(controller: ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Blood Type'),
                        value: _selectedBloodType,
                        items: _bloodTypes
                            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedBloodType = value),
                        validator: (value) => value == null ? 'Please select blood type' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _register,
                          child: const Text("Sign Up"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text("Login", style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
