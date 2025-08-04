import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RequestBloodFormPage extends StatefulWidget {
  const RequestBloodFormPage({super.key});

  @override
  State<RequestBloodFormPage> createState() => _RequestBloodFormPageState();
}

class _RequestBloodFormPageState extends State<RequestBloodFormPage> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  String? selectedBloodType;
  String? selectedUrgency;
  bool isSubmitting = false;

  final List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  final List<String> urgencies = ['low', 'medium', 'high'];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final token = await _secureStorage.read(key: 'token');
    final requestData = {
      "bloodType": selectedBloodType,
      "quantity": int.tryParse(_unitsController.text.trim()) ?? 1,
      "urgency": selectedUrgency,
      "phoneNumber": int.tryParse(_phoneController.text.trim()),
      "issueDescription": _reasonController.text.trim(),
      "location": _locationController.text.trim(),
    };

    print('📦 Request Data: $requestData');

    try {
      final response = await _dio.post(
        'http://192.168.101.4:5000/api/requests/',
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ ${response.data["message"] ?? "Request submitted!"}',
            ),
          ),
        );

        // Reset form and go to dashboard
        _formKey.currentState!.reset();
        setState(() {
          selectedBloodType = null;
          selectedUrgency = null;
        });

        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // small delay for UX
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      debugPrint("❌ Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Failed to submit blood request')),
        );
      }
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Blood'),
        backgroundColor: const Color(0xFFE53E3E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: selectedBloodType,
                decoration: const InputDecoration(
                  labelText: 'Blood Type',
                  border: OutlineInputBorder(),
                ),
                items:
                    bloodTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged: (value) => setState(() => selectedBloodType = value),
                validator:
                    (value) =>
                        value == null ? 'Please select a blood type' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedUrgency,
                decoration: const InputDecoration(
                  labelText: 'Urgency',
                  border: OutlineInputBorder(),
                ),
                items:
                    urgencies
                        .map(
                          (urgency) => DropdownMenuItem(
                            value: urgency,
                            child: Text(urgency),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => selectedUrgency = value),
                validator:
                    (value) =>
                        value == null ? 'Please select urgency level' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboard: TextInputType.phone,
              ),
              _buildTextField(
                controller: _unitsController,
                label: 'Quantity (units)',
                keyboard: TextInputType.number,
              ),
              _buildTextField(
                controller: _locationController,
                label: 'Location',
              ),
              _buildTextField(
                controller: _reasonController,
                label: 'Issue Description',
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53E3E),
                ),
                child:
                    isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        validator:
            (value) => value == null || value.isEmpty ? 'Required field' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
