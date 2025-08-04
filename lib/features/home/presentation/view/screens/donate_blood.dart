import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DonateBloodFormPage extends StatefulWidget {
  const DonateBloodFormPage({super.key});

  @override
  State<DonateBloodFormPage> createState() => _DonateBloodFormPageState();
}

class _DonateBloodFormPageState extends State<DonateBloodFormPage> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  String userId = '';
  String? bloodType;
  String email = '';
  String phone = '';
  int units = 1;
  String? selectedLocation;
  List<String> locations = [];
  bool isLoading = true;

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

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  Future<void> _loadFormData() async {
    try {
      userId = await secureStorage.read(key: 'userId') ?? '';
      bloodType = await secureStorage.read(key: 'bloodType');
      email = await secureStorage.read(key: 'email') ?? '';
      phone = await secureStorage.read(key: 'phone') ?? '';
      final token = await secureStorage.read(key: 'token') ?? '';

      final dio = Dio();
      final response = await dio.get(
        'http://192.168.101.4:5000/api/camps/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List camps = response.data['data'];
      setState(() {
        locations =
            camps
                .map<String>((camp) => camp['location'] as String)
                .toSet()
                .toList();
        if (!locations.contains(selectedLocation)) {
          selectedLocation = null;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching camps: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to load camp locations")),
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final token = await secureStorage.read(key: 'token');
      try {
        final dio = Dio();
        final response = await dio.post(
          'http://192.168.101.4:5000/api/donations',
          data: {
            'userId': userId,
            'bloodType': bloodType,
            'units': units,
            'location': selectedLocation,
            'email': email,
            'phone': phone,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        debugPrint("Donation response: ${response.data}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ ${response.data['message']}")),
        );

        // Reset state and navigate
        setState(() {
          bloodType = null;
          selectedLocation = null;
          units = 1;
          email = '';
          phone = '';
        });

        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushReplacementNamed(context, '/dashboard');
        });
      } catch (e) {
        debugPrint("Donation error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("❌ Donation failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Donate Blood'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_blood.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextFormField(
                                  initialValue: userId,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: 'User ID',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Email
                                TextFormField(
                                  initialValue: email,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator:
                                      (value) =>
                                          value == null || value.isEmpty
                                              ? 'Enter your email'
                                              : null,
                                  onChanged: (value) => email = value,
                                ),
                                const SizedBox(height: 16),

                                // Phone
                                TextFormField(
                                  initialValue: phone,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator:
                                      (value) =>
                                          value == null || value.isEmpty
                                              ? 'Enter your phone number'
                                              : null,
                                  onChanged: (value) => phone = value,
                                ),
                                const SizedBox(height: 16),

                                // Blood Type Dropdown
                               DropdownButtonFormField<String>(
                                  value:
                                      bloodTypes.contains(bloodType)
                                          ? bloodType
                                          : null,
                                  decoration: const InputDecoration(
                                    labelText: 'Blood Type',
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      bloodTypes
                                          .map(
                                            (type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(type),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    setState(() => bloodType = value);
                                  },
                                  validator:
                                      (value) =>
                                          value == null
                                              ? 'Please select a blood type'
                                              : null,
                                ),

                                const SizedBox(height: 16),

                                // Units
                                TextFormField(
                                  initialValue: units.toString(),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Units to Donate',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    final val = int.tryParse(value ?? '');
                                    if (val == null || val < 1) {
                                      return 'Enter at least 1 unit';
                                    }
                                    return null;
                                  },
                                  onChanged:
                                      (value) =>
                                          units = int.tryParse(value) ?? 1,
                                ),
                                const SizedBox(height: 16),

                                // Location Dropdown
                                DropdownButtonFormField<String>(
                                  value: selectedLocation,
                                  decoration: const InputDecoration(
                                    labelText: 'Select Camp Location',
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      locations
                                          .map(
                                            (loc) => DropdownMenuItem(
                                              value: loc,
                                              child: Text(loc),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLocation = value;
                                    });
                                  },
                                  validator:
                                      (value) =>
                                          value == null
                                              ? 'Please select a location'
                                              : null,
                                ),
                                const SizedBox(height: 24),

                                ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Donate Now',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
