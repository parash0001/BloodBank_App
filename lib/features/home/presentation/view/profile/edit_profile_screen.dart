import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  // Controllers
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _age = TextEditingController();
  String? _bloodType;
  String _role = 'user';

  final List<String> _bloodTypes = [
    'A+',
    'A−',
    'B+',
    'B−',
    'AB+',
    'AB−',
    'O+',
    'O−',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    String? fullName = await _storage.read(key: 'name');
    if (fullName != null && fullName.trim().isNotEmpty) {
      List<String> nameParts = fullName.trim().split(' ');
      _firstName.text = nameParts.first;
      _lastName.text =
          nameParts.length > 1
              ? nameParts
                  .sublist(1)
                  .join(' ') // handle middle names as part of last name
              : '';
    }

    _email.text = await _storage.read(key: 'email') ?? '';
    _phone.text = await _storage.read(key: 'phone') ?? '';
    _age.text = await _storage.read(key: 'age') ?? '';
    _bloodType = await _storage.read(key: 'bloodType');
    _role = await _storage.read(key: 'role') ?? 'user';

    setState(() {});
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    String? token = await _storage.read(key: 'token');
    String? userId = await _storage.read(key: 'userId');

    final data = {
      "firstName": _firstName.text.trim(),
      "lastName": _lastName.text.trim(),
      "phone": _phone.text.trim(),
      "age": int.tryParse(_age.text.trim()) ?? 0,
      "bloodType": _bloodType,
    };

    try {
      final response = await _dio.put(
        "http://192.168.101.4:5000/api/users/$userId",
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        // Update SecureStorage
        await _storage.write(key: 'firstName', value: _firstName.text);
        await _storage.write(key: 'lastName', value: _lastName.text);
        await _storage.write(key: 'phone', value: _phone.text);
        await _storage.write(key: 'age', value: _age.text);
        await _storage.write(key: 'bloodType', value: _bloodType);

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("First Name", _firstName),
              _buildTextField("Last Name", _lastName),
              _buildTextField("Email", _email, readOnly: true),
              _buildTextField("Phone", _phone),
              _buildTextField("Age", _age, keyboardType: TextInputType.number),

              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _bloodType,
                decoration: InputDecoration(
                  labelText: 'Blood Type',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items:
                    _bloodTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _bloodType = value),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Select blood type'
                            : null,
              ),

              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                initialValue: _role,
                decoration: InputDecoration(
                  labelText: "Role",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Update Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
