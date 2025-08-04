import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  List<dynamic> _allRequests = [];
  List<dynamic> _filteredRequests = [];

  String _selectedBloodType = 'All';
  String _selectedUrgency = 'All';
  String _selectedStatus = 'All';
  String _selectedSort = 'Newest';
  String _role = '';

  final List<String> bloodTypes = [
    'All',
    'A+',
    'A−',
    'B+',
    'B−',
    'AB+',
    'AB−',
    'O+',
    'O−',
  ];
  final List<String> urgencyLevels = ['All', 'low', 'medium', 'high'];
  final List<String> statusOptions = ['All', 'pending', 'approved', 'rejected'];

  @override
  void initState() {
    super.initState();
    _loadRoleAndFetch();
  }

  Future<void> _loadRoleAndFetch() async {
    _role = await _storage.read(key: 'role') ?? '';
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) return;

      final response = await _dio.get(
        'http://192.168.101.4:5000/api/requests/',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data['success']) {
        final userData = response.data['data'][0];
        final requests = userData['requests'] as List<dynamic>;
        setState(() {
          _allRequests = requests;
          _applyFilters();
        });
      }
    } catch (e) {
      debugPrint("Error fetching requests: $e");
    }
  }

  void _applyFilters() {
    List<dynamic> filtered = _allRequests;

    if (_selectedBloodType != 'All') {
      filtered =
          filtered.where((r) => r['bloodType'] == _selectedBloodType).toList();
    }

    if (_selectedUrgency != 'All') {
      filtered =
          filtered.where((r) => r['urgency'] == _selectedUrgency).toList();
    }

    if (_selectedStatus != 'All') {
      filtered = filtered.where((r) => r['status'] == _selectedStatus).toList();
    }

    if (_selectedSort == 'Newest') {
      filtered.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
    } else {
      filtered.sort((a, b) => a['createdAt'].compareTo(b['createdAt']));
    }

    setState(() {
      _filteredRequests = filtered;
    });
  }

  void _editRequestDialog(Map<String, dynamic> request) {
    final bloodTypeCtrl = TextEditingController(text: request['bloodType']);
    final quantityCtrl = TextEditingController(
      text: request['quantity'].toString(),
    );
    final urgencyCtrl = TextEditingController(text: request['urgency']);
    final locationCtrl = TextEditingController(text: request['location']);
    final phoneCtrl = TextEditingController(text: request['phoneNumber']);
    final issueCtrl = TextEditingController(text: request['issueDescription']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Request"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: bloodTypeCtrl,
                  decoration: const InputDecoration(labelText: 'Blood Type'),
                ),
                TextField(
                  controller: quantityCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                ),
                TextField(
                  controller: urgencyCtrl,
                  decoration: const InputDecoration(labelText: 'Urgency'),
                ),
                TextField(
                  controller: locationCtrl,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: issueCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Issue Description',
                  ),
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
                try {
                  await _dio.patch(
                    'http://192.168.101.4:5000/api/requests/${request['_id']}',
                    data: {
                      'bloodType': bloodTypeCtrl.text.trim(),
                      'quantity': int.parse(quantityCtrl.text.trim()),
                      'urgency': urgencyCtrl.text.trim(),
                      'location': locationCtrl.text.trim(),
                      'phoneNumber': phoneCtrl.text.trim(),
                      'issueDescription': issueCtrl.text.trim(),
                    },
                    options: Options(
                      headers: {"Authorization": "Bearer $token"},
                    ),
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("✅ Request updated")),
                    );
                    _fetchRequests();
                  }
                } catch (e) {
                  debugPrint("Edit error: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("❌ Failed to update")),
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

  Future<void> _deleteRequest(String id) async {
    final token = await _storage.read(key: 'token');
    try {
      await _dio.delete(
        'http://192.168.101.4:5000/api/requests/$id',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Request deleted")));
      _fetchRequests();
    } catch (e) {
      debugPrint("Delete error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Failed to delete")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Request History'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildFilters(),
          const Divider(thickness: 1),
          Expanded(
            child:
                _filteredRequests.isEmpty
                    ? const Center(child: Text("No requests found"))
                    : ListView.builder(
                      itemCount: _filteredRequests.length,
                      itemBuilder: (context, index) {
                        final request = _filteredRequests[index];
                        final createdDate = DateFormat.yMMMEd().add_jm().format(
                          DateTime.parse(request['createdAt']),
                        );

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Blood Type: ${request['bloodType']}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text("Quantity: ${request['quantity']} units"),
                                Text("Urgency: ${request['urgency']}"),
                                Text("Status: ${request['status']}"),
                                Text("Location: ${request['location']}"),
                                Text("Phone: ${request['phoneNumber']}"),
                                Text("Issue: ${request['issueDescription']}"),
                                const SizedBox(height: 6),
                                Text(
                                  "Requested on: $createdDate",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                if (_role == 'admin')
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed:
                                            () => _editRequestDialog(request),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () =>
                                                _deleteRequest(request['_id']),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          _buildDropdown("Blood", bloodTypes, _selectedBloodType, (val) {
            setState(() {
              _selectedBloodType = val!;
              _applyFilters();
            });
          }),
          _buildDropdown("Urgency", urgencyLevels, _selectedUrgency, (val) {
            setState(() {
              _selectedUrgency = val!;
              _applyFilters();
            });
          }),
          _buildDropdown("Status", statusOptions, _selectedStatus, (val) {
            setState(() {
              _selectedStatus = val!;
              _applyFilters();
            });
          }),
          _buildDropdown("Sort", ['Newest', 'Oldest'], _selectedSort, (val) {
            setState(() {
              _selectedSort = val!;
              _applyFilters();
            });
          }),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        DropdownButton<String>(
          value: value,
          items:
              options
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          onChanged: onChanged,
          underline: Container(height: 1, color: Colors.grey.shade300),
        ),
      ],
    );
  }
}
