import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService; // Changed from storageService to _storageService
  bool _isInitializing = true;
  bool _isAuthenticated = false;
  bool _isLoggedIn = false;
  String? _mobile;
  String? _userId;
  
  // Getters remain the same
  String? get mobile => _mobile;
  String? get userId => _userId;
  bool get isLoggedIn => _isLoggedIn;
  bool get isInitializing => _isInitializing;
  bool get isAuthenticated => _isAuthenticated;

  // Keep only one constructor
  AuthProvider({required StorageService storageService}) 
      : _storageService = storageService {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final token = await _storageService.getToken();
      _isAuthenticated = token != null;
    } catch (e) {
      print('Auth check error: $e');
      _isAuthenticated = false;
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, DateTime dob, String gender, 
      String aadhaar, String mobile) async {
    try {
      final data = await _apiService.registerUser(
        name, dob, gender, aadhaar, mobile);
      await _storageService.saveToken(data['token']);
      _mobile = mobile;
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      print('Auth provider register error: $e');
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> requestOtp(String mobile) async {
    await _apiService.requestOtp(mobile);
    _mobile = mobile;
    notifyListeners();
  }

  Future<void> verifyOtp(String mobile, String otp) async {
    try {
      final data = await _apiService.verifyOtp(mobile, otp);
      await _storageService.saveToken(data['token']);
      
      // Extract userId from JWT token
      final token = data['token'];
      final parts = token.split('.');
      if (parts.length > 1) {
        final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
        );
        _userId = payload['id'];
      }
      
      _mobile = mobile;
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      print('Verify OTP Error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
    _mobile = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // Add this method to get the stored token
  Future<String?> getToken() async {
    return await _storageService.getToken();
  }
}