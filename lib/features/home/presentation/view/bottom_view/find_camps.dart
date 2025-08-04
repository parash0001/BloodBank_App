import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class FindCampTab extends StatefulWidget {
  const FindCampTab({super.key});

  @override
  State<FindCampTab> createState() => _FindCampTabState();
}

class _FindCampTabState extends State<FindCampTab> {
  final _dio = Dio();
  final _storage = const FlutterSecureStorage();

  List<dynamic> _camps = [];
  String _role = '';
  String _filterStatus = 'All';

  final List<String> _statuses = ['All', 'Active', 'Upcoming', 'Past'];

  @override
  void initState() {
    super.initState();
    _fetchCamps();
  }

  Future<void> _fetchCamps() async {
    final token = await _storage.read(key: 'token');
    final role = await _storage.read(key: 'role') ?? '';
    setState(() => _role = role);

    try {
      final res = await _dio.get(
        'http://192.168.101.4:5000/api/camps/',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (res.statusCode == 200 && res.data['success']) {
        final camps = res.data['data'] as List;
        setState(() => _camps = camps);
      }
    } catch (e) {
      debugPrint("Failed to fetch camps: $e");
    }
  }

  bool _matchStatus(dynamic camp) {
    final campDate = DateTime.parse(camp['date']);
    final now = DateTime.now();

    switch (_filterStatus) {
      case 'Active':
        return DateUtils.isSameDay(campDate, now);
      case 'Upcoming':
        return campDate.isAfter(now);
      case 'Past':
        return campDate.isBefore(now);
      default:
        return true;
    }
  }

  Future<void> _deleteCamp(String id) async {
    final token = await _storage.read(key: 'token');
    try {
      await _dio.delete(
        'http://192.168.101.4:5000/api/camps/$id',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Camp deleted")));
      _fetchCamps(); // refresh
    } catch (e) {
      debugPrint("Delete error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to delete camp")));
    }
  }

  void _showAddCampDialog() async {
    final token = await _storage.read(key: 'token');
    final role = await _storage.read(key: 'role') ?? '';

    if (role != 'admin' || token == null) {
      return;
    }

    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final dateController = TextEditingController();
    final organizerController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Blood Camp"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: "Date & Time (yyyy-MM-dd HH:mm)",
                  ),
                ),
                TextField(
                  controller: organizerController,
                  decoration: const InputDecoration(labelText: "Organizer"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final newCamp = {
                    "title": titleController.text.trim(),
                    "location": locationController.text.trim(),
                    "date":
                        DateTime.parse(
                          dateController.text.trim(),
                        ).toIso8601String(),
                    "organizer": organizerController.text.trim(),
                    "description": descriptionController.text.trim(),
                  };

                  final res = await _dio.post(
                    'http://192.168.101.4:5000/api/camps/',
                    data: newCamp,
                    options: Options(
                      headers: {"Authorization": "Bearer $token"},
                    ),
                  );

                  final success = res.data['success'];
                  final message = res.data['message'] ?? 'Camp added';

                  if (success) {
                    Navigator.pop(context);
                    _fetchCamps(); // refresh list
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("✅ $message")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("❌ Failed: $message")),
                    );
                  }
                } catch (e) {
                  debugPrint("Add camp error: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("❌ Failed to add camp")),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _editCamp(Map<String, dynamic> camp) {
    final titleController = TextEditingController(text: camp['title']);
    final locationController = TextEditingController(text: camp['location']);
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(camp['date'])),
    );
    final organizerController = TextEditingController(text: camp['organizer']);
    final descriptionController = TextEditingController(
      text: camp['description'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Camp"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                ),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Date & Time (yyyy-MM-dd HH:mm)",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2100),
                    );

                    if (selectedDate != null) {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedTime != null) {
                        final combinedDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );

                        dateController.text = DateFormat(
                          'yyyy-MM-dd HH:mm',
                        ).format(combinedDateTime);
                      }
                    }
                  },
                ),

                TextField(
                  controller: organizerController,
                  decoration: const InputDecoration(labelText: "Organizer"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final token = await _storage.read(key: 'token');
                if (token == null) return;

                try {
                  final updatedCamp = {
                    "title": titleController.text.trim(),
                    "location": locationController.text.trim(),
                    "date":
                        DateTime.parse(
                          dateController.text.trim(),
                        ).toIso8601String(),
                    "organizer": organizerController.text.trim(),
                    "description": descriptionController.text.trim(),
                  };

                  final response = await _dio.patch(
                    'http://192.168.101.4:5000/api/camps/${camp['_id']}', // this still works since you're passing the original `camp` from the list
                    data: updatedCamp,
                    options: Options(
                      headers: {"Authorization": "Bearer $token"},
                    ),
                  );
                  print(response.data);

                  final success = response.data['success'];
                  final message =
                      response.data['message'] ?? 'Update successful';

                  if (success) {
                    Navigator.pop(context); // Close popup
                    _fetchCamps(); // Refresh list
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("✅ $message")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("❌ Failed: $message")),
                    );
                  }
                } catch (e) {
                  debugPrint("Edit error: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("❌ Failed to update camp")),
                  );
                }
              },

              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCamps = _camps.where(_matchStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Blood Camps"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (_role == 'admin')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddCampDialog,
              tooltip: "Host a Blood Camp",
            ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildFilters(),
          const Divider(),
          Expanded(
            child:
                filteredCamps.isEmpty
                    ? const Center(child: Text("No camps found"))
                    : ListView.builder(
                      itemCount: filteredCamps.length,
                      itemBuilder: (context, index) {
                        final camp = filteredCamps[index];
                        final date = DateFormat.yMMMEd().format(
                          DateTime.parse(camp['date']),
                        );
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: const Color(0xFFF8F8FF), // soft light color
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Main Info Column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        camp['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              camp['location'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.deepPurple,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            DateFormat.yMMMEd().format(
                                              DateTime.parse(camp['date']),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.people,
                                            size: 16,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              "Organizer: ${camp['organizer']}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        camp['description'],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),

                                // Admin Actions
                                if (_role == 'admin')
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () => _editCamp(camp),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () => _deleteCamp(camp['_id']),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Text("Filter:", style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 12),
          DropdownButton<String>(
            value: _filterStatus,
            items:
                _statuses
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (val) {
              setState(() => _filterStatus = val!);
            },
          ),
        ],
      ),
    );
  }
}
