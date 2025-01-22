import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicationsScreenContent extends StatefulWidget {
  const MedicationsScreenContent({super.key});

  @override
  State<MedicationsScreenContent> createState() => _MedicationsScreenContentState();
}

class _MedicationsScreenContentState extends State<MedicationsScreenContent> {
  bool _isLoading = false;
  List<Map<String, String>> _medications = [];
  final _searchController = TextEditingController();
  List<Map<String, String>> _filteredMedications = [];

  @override
  void initState() {
    super.initState();
    _fetchMedications();
  }

  Future<void> _fetchMedications() async {
    setState(() => _isLoading = true);
    
    try {
      final token = await Provider.of<AuthProvider>(context, listen: false).getToken();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/v1/profile/get'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        final medicationsList = userData['medications'] as List? ?? [];
        
        setState(() {
          if (medicationsList.isEmpty) {
            _medications = [
              {'name': 'Anti-biotics', 'dosage': '500mg'},
              {'name': 'Nasal Spray', 'dosage': ''},
              {'name': 'Pain Reliever', 'dosage': '200mg'},
              {'name': 'Vitamin D', 'dosage': '1000 IU'},
            ];
          } else {
            _medications = medicationsList.map((med) {
              if (med is String) {
                final parts = med.split('-');
                return {
                  'name': parts[0].trim(),
                  'dosage': parts.length > 1 ? parts[1].trim() : '',
                };
              }
              return {
                'name': (med['name'] ?? '').toString(),
                'dosage': (med['dosage'] ?? '').toString(),
              };
            }).toList();
          }
          _filteredMedications = _medications;
        });
      }
    } catch (e) {
      print('Error fetching medications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load medications: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterMedications(String query) {
    setState(() {
      _filteredMedications = _medications.where((med) {
        return med['name']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text('My Medications'),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterMedications,
                    decoration: InputDecoration(
                      hintText: 'Search medications...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredMedications.isEmpty
                      ? const Center(child: Text('No medications found'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredMedications.length,
                          itemBuilder: (context, index) {
                            final medication = _filteredMedications[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.medication_rounded,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                medication['name']!,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (medication['dosage']!.isNotEmpty)
                                                Text(
                                                  medication['dosage']!,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                            ],
                                          ),
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
}