import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class RegisterFingerprintScreen extends StatelessWidget {
  const RegisterFingerprintScreen({super.key});

  Future<void> _registerFingerprint(BuildContext context) async {
    final auth = LocalAuthentication();
    final canCheck = await auth.canCheckBiometrics;

    if (!canCheck) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric not available')),
      );
      return;
    }

    final didAuth = await auth.authenticate(
      localizedReason: 'Authenticate to register fingerprint',
    );

    if (didAuth) {
      final storage = const FlutterSecureStorage();
      final email = await storage.read(key: 'email');
      final password = await storage.read(key: 'password');
      if (email != null && password != null) {
        await storage.write(key: 'fp_email', value: email);
        await storage.write(key: 'fp_password', value: password);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Fingerprint login enabled')),
          );
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Fingerprint')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _registerFingerprint(context),
          icon: const Icon(Icons.fingerprint),
          label: const Text('Register Fingerprint'),
        ),
      ),
    );
  }
}
