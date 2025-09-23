import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfileClient {
  static const String baseUrl = 'http://ton-backend.com/api';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Get client profile with fallback to test data
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        return _getTestData();
      }

      final url = Uri.parse('$baseUrl/client/profile');

      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        // If API fails, return test data
        return _getTestData();
      }
    } catch (e) {
      // If any error occurs, return test data
      return _getTestData();
    }
  }

  // Update client profile
  static Future<String?> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        return 'No authentication token found';
      }

      final url = Uri.parse('$baseUrl/client/profile');

      final response = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(profileData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return null; // success
      } else {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Failed to update profile';
      }
    } catch (e) {
      return 'Network error: $e';
    }
  }

  // Test data fallback
  static Map<String, dynamic> _getTestData() {
    final now = DateTime.now();
    return {
      'client_id': 'test-client-id-123',
      'nom': 'Doe',
      'prenom': 'John',
      'email': 'john.doe@example.com',
      'telephone': '+1234567890',
      'adresse': '123 Main Street, City, Country',
      'username': 'johndoe',
      'date_creation': now.toString(),
      'derniere_connexion': now.toString(),
      'confirmed': true,
    };
  }
}
