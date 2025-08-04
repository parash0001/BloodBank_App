import 'package:flutter/material.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const donationCount = 5;
    const lastDonation = "July 10, 2025";
    const activeRequests = 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Information"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _statCard("Donations Made", "$donationCount times", Icons.volunteer_activism, Colors.redAccent),
          _statCard("Last Donation", lastDonation, Icons.calendar_today, Colors.blue),
          _statCard("Active Requests", "$activeRequests request(s)", Icons.help_outline, Colors.orange),
          const SizedBox(height: 24),
          const Text(
            "Keep donating to save lives and maintain a healthy blood supply network.",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 30, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
