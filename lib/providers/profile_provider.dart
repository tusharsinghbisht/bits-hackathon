import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class ProfileProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProfile(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/v1/profile/get'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _user = User.fromJson(jsonDecode(response.body));
      } else {
        _error = 'Failed to load profile';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(String token, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/v1/profile/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        _user = User.fromJson(jsonDecode(response.body));
        notifyListeners();
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      rethrow;
    }
  }
}