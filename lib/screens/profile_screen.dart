import 'package:centralised_health/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/auth_provider.dart';
import 'package:intl/intl.dart';

class ProfileScreenContent extends StatefulWidget {
  const ProfileScreenContent({super.key});

  @override
  State<ProfileScreenContent> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreenContent> {
  bool _isLoading = false;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers for editable fields
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _surgeriesController = TextEditingController();

  // Add new state variables
  String _userAge = '';
  String _userName = '';
  DateTime? _userDob;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() => _isLoading = true);

    try {
      final token = await Provider.of<AuthProvider>(context, listen: false).getToken();
      print('Token for profile fetch: $token');

      if (token != null) {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8000/api/v1/profile/get'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        print('Profile Response Status: ${response.statusCode}');
        print('Profile Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);
          _userDob = DateTime.parse(userData['dob']);
          _userName = userData['name'];

          // Calculate age
          final today = DateTime.now();
          var age = today.year - _userDob!.year;
          if (today.month < _userDob!.month ||
              (today.month == _userDob!.month && today.day < _userDob!.day)) {
            age--;
          }

          setState(() {
            _userAge = age.toString();
            // Update other controllers
            _heightController.text = userData['height']?.toString() ?? '';
            _weightController.text = userData['weight']?.toString() ?? '';
            _bloodGroupController.text = userData['bloodGroup'] ?? '';
            _surgeriesController.text = (userData['surgeries'] as List?)?.join(', ') ?? '';
          });
        } else {
          throw Exception('Failed to load profile: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error fetching profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await Provider.of<AuthProvider>(context, listen: false).getToken();
    if (token == null) return;

    try {
      await Provider.of<ProfileProvider>(context, listen: false).updateProfile(
        token,
        {
          'height': double.tryParse(_heightController.text),
          'weight': double.tryParse(_weightController.text),
          'bloodGroup': _bloodGroupController.text,
          'surgeries': _surgeriesController.text.split(',').map((e) => e.trim()).toList(),
        },
      );
      setState(() => _isEditing = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.primaryColor,
        title: const Text(
          'Medical Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save_rounded : Icons.edit_rounded,
              color: Colors.white,
            ),
            onPressed: () => setState(() {
              if (_isEditing) {
                _saveChanges();
              } else {
                _isEditing = true;
              }
            }),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: theme.primaryColor,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 30,
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Age: $_userAge years',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        if (_userDob != null)
                          Text(
                            'DOB: ${DateFormat('dd MMM yyyy').format(_userDob!)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSection(
                            title: 'Physical Details',
                            icon: Icons.height_rounded,
                            children: [
                              _buildEditableField(
                                label: 'Height (cm)',
                                controller: _heightController,
                                enabled: _isEditing,
                                keyboardType: TextInputType.number,
                              ),
                              _buildEditableField(
                                label: 'Weight (kg)',
                                controller: _weightController,
                                enabled: _isEditing,
                                keyboardType: TextInputType.number,
                              ),
                              _buildEditableField(
                                label: 'Blood Group',
                                controller: _bloodGroupController,
                                enabled: _isEditing,
                              ),
                            ],
                          ),
                          const Divider(height: 1),
                          _buildSection(
                            title: 'Medical History',
                            icon: Icons.history_edu_rounded,
                            children: [
                              _buildEditableField(
                                label: 'Past Surgeries',
                                controller: _surgeriesController,
                                enabled: _isEditing,
                                maxLines: 3,
                              ),
                            ],
                          ),
                          const Divider(height: 1),
                          _buildSection(
                            title: 'Current Conditions',
                            icon: Icons.medical_information_rounded,
                            children: [
                              _buildConditionsList('Acute Conditions', ['Fever', 'Cold']),
                              _buildConditionsList('Chronic Conditions', ['Diabetes', 'Hypertension']),
                            ],
                          ),
                          const Divider(height: 1),
                          _buildSection(
                            title: 'Allergies',
                            icon: Icons.warning_rounded,
                            children: [
                              _buildAllergiesList(['Peanuts', 'Penicillin']),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: !enabled,
          fillColor: enabled ? null : Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildConditionsList(String title, List<String> conditions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...conditions.map((condition) => Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(condition),
                ],
              ),
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAllergiesList(List<String> allergies) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allergies
          .map((allergy) => Chip(
                label: Text(allergy),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ))
          .toList(),
    );
  }
}