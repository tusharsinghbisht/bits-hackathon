import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<dynamic> _documents = [];
  List<dynamic> _filteredDocuments = [];
  String _selectedType = 'report';
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _downloadingFiles = {};

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
    _searchController.addListener(_filterReports);
  }

  Future<void> _downloadFile(String url, String fileName) async {
    setState(() => _downloadingFiles[fileName] = true);
    
    try {
      if (await Permission.storage.request().isGranted) {
        final response = await http.get(Uri.parse('http://10.0.2.2:8000$url'));
        
        Directory? directory;
        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download');
        } else {
          directory = await getApplicationDocumentsDirectory();
        }
        
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded: ${directory.path}/$fileName')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _downloadingFiles[fileName] = false);
      }
    }
  }

  Future<void> _fetchDocuments() async {
    final token = await Provider.of<AuthProvider>(context, listen: false).getToken();
    
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/v1/docs/user/get_all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final allDocs = jsonDecode(response.body);
        setState(() {
          _documents = List<Map<String, dynamic>>.from(allDocs);
          _filterReports();
        });
      } else {
        throw Exception('Failed to load documents: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load documents: $e')),
      );
    }
  }

  Future<Map<String, dynamic>> _fetchAgencyDetails(String agencyId) async {
    final token = await Provider.of<AuthProvider>(context, listen: false).getToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/v1/profile/agency/$agencyId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load agency details');
    }
  }

  Future<void> _showReportDetails(Map<String, dynamic> doc) async {
    try {
      final agencyDetails = await _fetchAgencyDetails(doc['agencyId']);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(doc['file'].split('/').last),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Agency: ${agencyDetails['name']}'),
                Text('Location: ${agencyDetails['location']}'),
                Text('Created: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(doc['createdAt']))}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () => _downloadFile(doc['file'], doc['file'].split('/').last),
                child: const Text('Download'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(doc['file'].split('/').last),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Failed to load agency details'),
                Text('Created: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(doc['createdAt']))}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () => _downloadFile(doc['file'], doc['file'].split('/').last),
                child: const Text('Download'),
              ),
            ],
          );
        },
      );
    }
  }

  void _filterReports() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDocuments = _documents.where((doc) {
        final name = doc['file'].toLowerCase();
        final date = doc['createdAt'].toLowerCase();
        final type = doc['type'].toLowerCase();
        return (name.contains(query) || date.contains(query)) && type == _selectedType;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedType == 'report' ? 'Reports' : 'Prescriptions'),
        actions: [
          DropdownButton<String>(
            value: _selectedType,
            items: const [
              DropdownMenuItem(value: 'report', child: Text('Reports')),
              DropdownMenuItem(value: 'prescription', child: Text('Prescriptions')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
                _filterReports();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredDocuments.length,
              itemBuilder: (context, index) {
                final doc = _filteredDocuments[index];
                final fileName = doc['file'].split('/').last;
                final isDownloading = _downloadingFiles[fileName] ?? false;
                final date = DateTime.parse(doc['createdAt']);
                
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(_selectedType == 'report' 
                        ? Icons.description 
                        : Icons.medical_services),
                    title: Text(fileName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Created: ${DateFormat('dd MMM yyyy, hh:mm a').format(date)}'),
                        FutureBuilder<Map<String, dynamic>>(
                          future: _fetchAgencyDetails(doc['agencyId']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text('Loading agency details...');
                            } else if (snapshot.hasError) {
                              return const Text('Failed to load agency details');
                            } else {
                              final agencyDetails = snapshot.data!;
                              return Text('Agency: ${agencyDetails['name']}');
                            }
                          },
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: isDownloading 
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.download),
                      onPressed: isDownloading 
                          ? null 
                          : () => _downloadFile(doc['file'], fileName),
                    ),
                    onTap: () => _showReportDetails(doc),
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