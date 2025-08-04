import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class DonationHistoryPage extends StatefulWidget {
  const DonationHistoryPage({super.key});

  @override
  State<DonationHistoryPage> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage> {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  List<dynamic> _allDonations = [];
  List<dynamic> _filteredDonations = [];

  String _selectedBloodType = 'All';
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

  @override
  void initState() {
    super.initState();
    _loadRoleAndDonations();
  }

  Future<void> _loadRoleAndDonations() async {
    final role = await _storage.read(key: 'role') ?? '';
    setState(() => _role = role);
    _fetchDonations();
  }

  Future<void> _fetchDonations() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) return;

      final response = await _dio.get(
        'http://192.168.101.4:5000/api/donations',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data['success']) {
        final userData = response.data['data'][0];
        final donations = userData['donations'] as List<dynamic>;

        setState(() {
          _allDonations = donations;
          _applyFilters();
        });
      }
    } catch (e) {
      debugPrint("Error fetching donations: $e");
    }
  }

  Future<void> _deleteDonation(String donationId) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) return;

      final res = await _dio.delete(
        'http://192.168.101.4:5000/api/donations/$donationId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (res.statusCode == 200 && res.data['success']) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("✅ Donation deleted")));
        _fetchDonations(); // refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "❌ Failed: ${res.data['message'] ?? 'Unknown error'}",
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Delete donation error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to delete donation")),
      );
    }
  }

  void _applyFilters() {
    List<dynamic> filtered = _allDonations;

    if (_selectedBloodType != 'All') {
      filtered =
          filtered.where((d) => d['bloodType'] == _selectedBloodType).toList();
    }

    if (_selectedSort == 'Newest') {
      filtered.sort((a, b) => b['donatedAt'].compareTo(a['donatedAt']));
    } else {
      filtered.sort((a, b) => a['donatedAt'].compareTo(b['donatedAt']));
    }

    setState(() {
      _filteredDonations = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Donation History'),
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
                _filteredDonations.isEmpty
                    ? const Center(child: Text("No donations found"))
                    : ListView.builder(
                      itemCount: _filteredDonations.length,
                      itemBuilder: (context, index) {
                        final donation = _filteredDonations[index];
                        final date = DateFormat.yMMMEd().add_jm().format(
                          DateTime.parse(donation['donatedAt']),
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Main content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Blood Type: ${donation['bloodType']}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text("Units: ${donation['units']}"),
                                      Text("Location: ${donation['location']}"),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Donated on: $date",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Delete icon for admin
                                if (_role == 'admin')
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed:
                                        () => _deleteDonation(donation['_id']),
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
