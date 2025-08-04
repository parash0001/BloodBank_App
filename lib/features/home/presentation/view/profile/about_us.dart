import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Icon(Icons.favorite, color: Colors.redAccent, size: 80),
          SizedBox(height: 16),
          Text(
            "Empowering Lives Through Blood Donation",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            "At LifeFlow, we are a community-powered blood donation platform with a mission to save lives through timely donations. "
            "Founded in 2024, we aim to bridge the gap between voluntary donors and those in need.",
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          SizedBox(height: 24),
          Text(
            "Why Choose Us?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text("• Real-time donor-recipient matching\n"
              "• Secure and private data handling\n"
              "• Notifications for nearby donation camps\n"
              "• Verified donors & requests",
              style: TextStyle(fontSize: 16, height: 1.6)),
        ],
      ),
    );
  }
}
