import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class FeedbackHistoryScreen extends StatefulWidget {
  const FeedbackHistoryScreen({super.key});

  @override
  State<FeedbackHistoryScreen> createState() => _FeedbackHistoryScreenState();
}

class _FeedbackHistoryScreenState extends State<FeedbackHistoryScreen> {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  List<dynamic> _feedbacks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFeedbacks();
  }

  Future<void> _fetchFeedbacks() async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await _dio.get(
        'http://192.168.101.4:5000/api/feedbacks/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success']) {
        setState(() {
          _feedbacks = response.data['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching feedbacks: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback History"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _feedbacks.isEmpty
              ? const Center(child: Text("No feedback submitted yet."))
              : ListView.builder(
                itemCount: _feedbacks.length,
                itemBuilder: (context, index) {
                  final item = _feedbacks[index];
                  final createdDate = DateFormat.yMMMEd().add_jm().format(
                    DateTime.parse(item['createdAt']),
                  );
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${item['type']}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text("Subject: ${item['subject']}"),
                          Text("Message: ${item['message']}"),
                          Text("Status: ${item['status']}"),
                          Text(
                            "Submitted on: $createdDate",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
