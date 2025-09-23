import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfileCooperative {
  static const String baseUrl = 'http://ton-backend.com/api';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Get cooperative profile with fallback to test data
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        return _getTestData();
      }

      final url = Uri.parse('$baseUrl/cooperative/profile');

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
        return _getTestData();
      }
    } catch (e) {
      return _getTestData();
    }
  }

  // Update cooperative profile
  static Future<String?> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        return 'No authentication token found';
      }

      final url = Uri.parse('$baseUrl/cooperative/profile');

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
      'cooperative_id': 'test-cooperative-id-789',
      'email': 'contact@artisancollective.com',
      'telephone': '+1122334455',
      'brand': 'Artisan Collective',
      'adresse': '456 Craft Avenue, City, Country',
      'description':
          'A collective of skilled artisans specializing in traditional crafts',
      'licence': 'LIC-789123',
      'statut_verification': true,
      'date_creation': now.toString(),
      'derniere_connexion': now.toString(),
      'confirmed': true,
    };
  }
}
