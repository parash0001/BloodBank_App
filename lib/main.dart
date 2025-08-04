import 'dart:math';
import 'package:bloodbank/app.dart';
import 'package:bloodbank/app/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sensors_plus/sensors_plus.dart';

// Global keys for navigation and snackbar
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(SensorWrapper(child: BloodBankApp()));
}

class SensorWrapper extends StatefulWidget {
  final Widget child;
  const SensorWrapper({super.key, required this.child});

  @override
  State<SensorWrapper> createState() => _SensorWrapperState();
}

class _SensorWrapperState extends State<SensorWrapper> {
  final _storage = const FlutterSecureStorage();
  bool _isLoggingOut = false; // Prevent multiple logouts from repeated shakes

  @override
  void initState() {
    super.initState();

    accelerometerEvents.listen((AccelerometerEvent event) {
      final double acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      final double delta = (acceleration - 9.8).abs();

      if (delta > 15.0 && !_isLoggingOut) {
        _isLoggingOut = true;
        print("Shake detected! Logging out...");
        _handleLogout();
      }
    });
  }

  Future<void> _handleLogout() async {
    final fpEmail = await _storage.read(key: 'fp_email');
    final fpPassword = await _storage.read(key: 'fp_password');

    const keysToDelete = [
      'token',
      'userId',
      'name',
      'email',
      'role',
      'password',
    ];

    for (final key in keysToDelete) {
      await _storage.delete(key: key);
    }

    // Restore fingerprint login credentials
    if (fpEmail != null) {
      await _storage.write(key: 'fp_email', value: fpEmail);
    }
    if (fpPassword != null) {
      await _storage.write(key: 'fp_password', value: fpPassword);
    }

    // Show logout message
    messengerKey.currentState?.showSnackBar(
      const SnackBar(content: Text('👋 Logged out due to shake')),
    );

    // Navigate to login page
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);

    // Allow shake logout again after 1.5 seconds
    await Future.delayed(const Duration(milliseconds: 1500));
    _isLoggingOut = false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
