import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _dio = Dio();
  final _storage = const FlutterSecureStorage();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final feedback = _controller.text.trim();
    final token = await _storage.read(key: 'token');

    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ User not logged in.")));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final response = await _dio.post(
        'http://192.168.101.4:5000/api/feedbacks/',
        data: {
          'type': 'suggestion',
          'subject': 'General Feedback',
          'message': feedback,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final serverMessage = response.data['message'] ?? 'Feedback submitted.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ $serverMessage")));
      _controller.clear();
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ??
          '❌ Submission failed. Please try again.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ An unexpected error occurred.")),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Issue / Feedback"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Help us improve by sharing your feedback or reporting issues.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: "Your message",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? "Please enter feedback"
                            : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: const Icon(Icons.send),
                label:
                    _isSubmitting
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text("Submit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/feedbackHistory');
                },
                icon: const Icon(Icons.history),
                label: const Text("See All Feedback History"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
