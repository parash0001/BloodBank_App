import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Icon(Icons.description_outlined, color: Colors.teal, size: 80),
          SizedBox(height: 16),
          Text(
            "Terms of Use",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            "By accessing and using the LifeFlow app, you agree to abide by the following terms:",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          Text("• You must provide accurate and honest information."),
          Text("• You must be eligible and medically fit to donate."),
          Text("• You agree not to misuse or impersonate others."),
          SizedBox(height: 16),
          Text("Disclaimer:", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            "LifeFlow acts only as a platform and does not conduct medical screenings. We are not liable for offline interactions or outcomes.",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
