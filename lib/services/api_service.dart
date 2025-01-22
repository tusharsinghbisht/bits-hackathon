import 'package:centralised_health/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1/auth/user';

  Future<Map<String, dynamic>> loginUser(String abhaId, String password) async {
    final response = await http.post(
      Uri.parse('https://nityamgandhi.pythonanywhere.com/login/user'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'abha_id': abhaId,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> registerUser(
    String name, 
    DateTime dob, 
    String gender, 
    String aadhaar, 
    String mobile
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'dob': dob.toIso8601String(),
          'gender': gender,
          'aadhaar': aadhaar,
          'mobile': mobile,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } 
      
      // Parse error response
      final errorBody = jsonDecode(response.body);
      if (errorBody['error']?.contains('duplicate key error') ?? false) {
        if (errorBody['error'].contains('aadhaar')) {
          throw Exception('Aadhaar number already registered');
        }
        if (errorBody['error'].contains('mobile')) {
          throw Exception('Mobile number already registered'); 
        }
      }
      
      throw Exception('Registration failed: ${response.body}');
    } catch (e) {
      print('Registration error: $e');
      rethrow; // Preserve the specific error message
    }
  }

  Future<void> requestOtp(String mobile) async {
    try {
      print('Requesting OTP for mobile: $mobile');
      final response = await http.post(
        Uri.parse('$baseUrl/login/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': mobile}),
      );

      print('OTP Request Status: ${response.statusCode}');
      print('OTP Response: ${response.body}');

      if (response.statusCode != 200) {
        final errorBody = jsonDecode(response.body);
        if (errorBody['error']?.contains('not found') ?? false) {
          throw Exception('Mobile number not registered');
        }
        throw Exception(errorBody['error'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      print('OTP Request Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String mobile, String otp) async {
    try {
      print('Verifying OTP for mobile: $mobile with OTP: $otp');
      
      final response = await http.post(
        Uri.parse('$baseUrl/login/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'mobile': mobile.replaceAll(RegExp(r'[^\d]'), ''),
          'otp': otp.trim(),
        }),
      );

      print('OTP Verify Status: ${response.statusCode}');
      print('OTP Verify Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      }

      final errorBody = jsonDecode(response.body);
      if (errorBody['error']?.contains('invalid')) {
        throw Exception('Invalid OTP entered');
      }
      if (errorBody['error']?.contains('expired')) {
        throw Exception('OTP has expired. Please request a new one');
      }
      throw Exception(errorBody['error'] ?? 'Failed to verify OTP');
      
    } catch (e) {
      print('OTP Verification Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _fetchAgencyDetails(String agencyId, BuildContext context) async {
    final token = await Provider.of<AuthProvider>(context, listen: false).getToken();
    print('Fetching agency details for ID: $agencyId');
    
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/v1/profile/agency/$agencyId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Agency details response status: ${response.statusCode}');
    print('Agency details response body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load agency details');
    }
  }
}