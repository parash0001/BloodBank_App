import 'package:bloodbank/app/service_locator/service_locator.dart';
import 'package:bloodbank/features/auth/presentation/view_model/login_view_model.dart';
import 'package:bloodbank/features/auth/presentation/view/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final viewModel = serviceLocator<LoginViewModel>();
  final auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    checkAutoLogin(context); // 👈 Call this on widget load
  }

 /// 🔐 Auto login if token exists
  Future<void> checkAutoLogin(BuildContext context) async {
    final token = await viewModel.secureStorage.read(key: 'token');
    if (token != null && token.isNotEmpty) {
      // Optionally verify token is still valid by calling a backend endpoint
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    viewModel.loginUser(email, password, context);
  }

  Future<void> _loginWithFingerprint() async {
  try {
    final didAuthenticate = await auth.authenticate(
      localizedReason: 'Login using fingerprint',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );

    if (didAuthenticate) {
      final email = await viewModel.secureStorage.read(key: 'fp_email');
      final password = await viewModel.secureStorage.read(key: 'fp_password');

      if (email != null && password != null) {
        viewModel.loginUser(email, password, context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ No fingerprint credentials found')),
        );
      }
    } else {
      // Fingerprint auth failed or cancelled – still navigate to dashboard for demo
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  } catch (e) {
    // Platform exception or device issue – still navigate to dashboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('⚠️ Biometric error: $e')),
    );
    // Navigator.pushReplacementNamed(context, '/dashboard');
  }
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFFFF1F2),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 120), // Adjusted for better layout
                    const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: 'demo@email.com',
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        hintText: 'Enter your password',
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton.icon(
                      icon: const Icon(Icons.fingerprint),
                      label: const Text("Login with Fingerprint"),
                      onPressed: _loginWithFingerprint,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an Account? "),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignupView()),
                          ),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

}
