import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfileDesigner {
  static const String baseUrl = 'http://ton-backend.com/api';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Get designer profile with fallback to test data
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        return _getTestData();
      }

      final url = Uri.parse('$baseUrl/designer/profile');

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

  // Update designer profile
  static Future<String?> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        return 'No authentication token found';
      }

      final url = Uri.parse('$baseUrl/designer/profile');

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
      'designer_id': 'test-designer-id-456',
      'nom': 'Smith',
      'prenom': 'Jane',
      'email': 'jane.smith@example.com',
      'telephone': '+0987654321',
      'username': 'janesmith',
      'specialites': 'Interior Design, Furniture Design',
      'tarifs': 45.00,
      'portfolio': 'janesmith-portfolio.com',
      'date_creation': now.toString(),
      'derniere_connexion': now.toString(),
      'confirmed': true,
    };
  }
}
