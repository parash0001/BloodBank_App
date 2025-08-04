import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = const FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();

  String? _name = 'Loading...';
  String? _email = 'Loading...';
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? name = await _storage.read(key: 'name');
    String? email = await _storage.read(key: 'email');
    String? image = await _storage.read(key: 'profileImage');

    setState(() {
      _name = name ?? 'Guest';
      _email = email ?? 'guest@example.com';
      _imageUrl = image;
    });
  }

  void _logout() async {
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

    // Restore fingerprint credentials
    if (fpEmail != null && fpPassword != null) {
      await _storage.write(key: 'fp_email', value: fpEmail);
      await _storage.write(key: 'fp_password', value: fpPassword);
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
Future<void> _enableFingerprintLogin() async {
  final canCheck = await auth.canCheckBiometrics;
  final isAvailable = await auth.isDeviceSupported();

  if (!canCheck || !isAvailable) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Fingerprint not supported on this device')),
      );
    }
    return;
  }

  // Show a progress dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final didAuthenticate = await auth.authenticate(
      localizedReason: 'Scan your fingerprint to enable quick login',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );

    Navigator.of(context).pop(); // Close progress dialog

    if (didAuthenticate) {
      final email = await _storage.read(key: 'email');
      final password = await _storage.read(key: 'password');

      if (email != null && password != null) {
        await _storage.write(key: 'fp_email', value: email);
        await _storage.write(key: 'fp_password', value: password);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Fingerprint login enabled!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ No email or password found to save')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Fingerprint authentication failed')),
        );
      }
    }
  } catch (e) {
    Navigator.of(context).pop(); // Ensure dialog is closed on error

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: ${e.toString()}')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final divider = const Divider(thickness: 1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Profile Page", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                    child: _imageUrl == null
                        ? const Icon(Icons.person, size: 45, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(_name ?? '',
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_email ?? '', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/editProfile'),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Profile'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Enable Fingerprint Login'),
                    onPressed: _enableFingerprintLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _ProfileTile(icon: Icons.info_outline, title: "Account Info", onTap: () => Navigator.pushNamed(context, '/accountInfo')),
            divider,
            _ProfileTile(icon: Icons.history, title: "Donation History", onTap: () => Navigator.pushNamed(context, '/donationHistory')),
            divider,
            _ProfileTile(icon: Icons.feedback_outlined, title: "Issue / Feedback", onTap: () => Navigator.pushNamed(context, '/feedback')),
            divider,
            _ProfileTile(icon: Icons.bloodtype_outlined, title: "About Us", onTap: () => Navigator.pushNamed(context, '/aboutUs')),
            divider,
            _ProfileTile(icon: Icons.privacy_tip_outlined, title: "Privacy Policy", onTap: () => Navigator.pushNamed(context, '/privacyPolicy')),
            divider,
            _ProfileTile(icon: Icons.description_outlined, title: "Terms & Conditions", onTap: () => Navigator.pushNamed(context, '/terms')),
            divider,
            const SizedBox(height: 30),
            OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text("Logout", style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
