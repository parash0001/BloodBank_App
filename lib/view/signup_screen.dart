import 'package:bloodbank/view/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void resetValidation() {
    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
    });
  }

  void onSignupPressed() {
    resetValidation();
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    bool hasError = false;

    setState(() {
      if (name.isEmpty) {
        nameError = "Name is required";
        hasError = true;
      }
      if (email.isEmpty || !email.contains('@')) {
        emailError = "Valid email required";
        hasError = true;
      }
      if (password.length < 6) {
        passwordError = "Password must be at least 6 characters";
        hasError = true;
      }
      if (confirmPassword != password) {
        confirmPasswordError = "Passwords do not match";
        hasError = true;
      }
    });

    if (!hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Signup successful"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          duration: const Duration(seconds: 2),
        ),
      );

      resetValidation();
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        resetValidation();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFCDD2),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Column(
                children: [
                  Image.asset(
                    'assets/images/banner1.jpg',
                    height: 80,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.error, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "BloodBank",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: ListView(
                    children: [
                      const Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInputField(
                        controller: nameController,
                        hintText: "Name",
                        icon: Icons.person_outline,
                        errorText: nameError,
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        controller: emailController,
                        hintText: "Email",
                        icon: Icons.email_outlined,
                        errorText: emailError,
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        controller: passwordController,
                        hintText: "Password",
                        icon: Icons.lock_outline,
                        obscureText: !isPasswordVisible,
                        suffixIcon:
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                        errorText: passwordError,
                        onSuffixTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        controller: confirmPasswordController,
                        hintText: "Confirm Password",
                        icon: Icons.lock_outline,
                        obscureText: !isConfirmPasswordVisible,
                        suffixIcon:
                            isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                        errorText: confirmPasswordError,
                        onSuffixTap: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: onSignupPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFCDD2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(fontFamily: 'OpenSans'),
                          ),
                          GestureDetector(
                            onTap: () {
                              resetValidation();
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFCDD2),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    IconData? suffixIcon,
    String? errorText,
    VoidCallback? onSuffixTap,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontFamily: 'OpenSans'),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontFamily: 'OpenSans'),
        prefixIcon: Icon(icon),
        suffixIcon:
            suffixIcon != null
                ? IconButton(icon: Icon(suffixIcon), onPressed: onSuffixTap)
                : null,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
