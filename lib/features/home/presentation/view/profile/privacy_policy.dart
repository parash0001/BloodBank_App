import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Icon(Icons.privacy_tip, color: Colors.blue, size: 80),
          SizedBox(height: 16),
          Text(
            "Our Commitment to Your Privacy",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            "We take your privacy seriously. This policy outlines how we collect, use, and protect your data.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          Text("What We Collect:", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text("• Full name, phone number, email, blood type\n• Donation and request history"),
          SizedBox(height: 16),
          Text("How It's Used:", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text("• Match you with nearby recipients or donors\n• Notify you of urgent needs and camps\n• Improve app features securely"),
          SizedBox(height: 24),
          Text(
            "We do not share your personal data with third parties without your consent.",
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
