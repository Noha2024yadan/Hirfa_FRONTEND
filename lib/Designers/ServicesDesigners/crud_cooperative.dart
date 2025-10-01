import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CrudCooperative {
  static const String baseUrl = 'http://ton-backend.com/api';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Get all cooperatives (for designer discovery)
  static Future<List<Map<String, dynamic>>> getAllCooperatives() async {
    try {
      final token = await _storage.read(key: 'jwt_token');

      final url = Uri.parse('$baseUrl/cooperatives');

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
        final cooperativesRaw = data['cooperatives'];

        if (cooperativesRaw is List) {
          return cooperativesRaw.cast<Map<String, dynamic>>();
        }
        return [];
      } else {
        return _getMockCooperatives();
      }
    } catch (e) {
      return _getMockCooperatives();
    }
  }

  // Get cooperative by ID
  static Future<Map<String, dynamic>?> getCooperativeById(
    String cooperativeId,
  ) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      final url = Uri.parse('$baseUrl/cooperatives/$cooperativeId');

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
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Contact cooperative
  static Future<String?> contactCooperative({
    required String cooperativeId,
    required String message,
  }) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      final url = Uri.parse('$baseUrl/cooperatives/$cooperativeId/contact');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'message': message}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return null;
      } else {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Failed to send message';
      }
    } catch (e) {
      return "Network or server error.";
    }
  }

  // Mock data for cooperatives
  static List<Map<String, dynamic>> _getMockCooperatives() {
    final now = DateTime.now();
    return [
      {
        "cooperative_id": "1",
        "brand": "Eco Crafts Collective",
        "description":
            "Sustainable craft products made from natural materials with traditional techniques.",
        "email": "contact@ecocrafts.com",
        "telephone": "+212 600-000001",
        "adresse": "Marrakech, Morocco",
        "products_count": 24,
        "licence": "LIC-789123",
        'statut_verification': true,
        'date_creation': now.toString(),
        'derniere_connexion': now.toString(),
        'confirmed': true,
        "images": ["https://picsum.photos/400/300"],
      },
      {
        "cooperative_id": "2",
        "brand": "Atlas Artisans",
        "description":
            "Premium handmade products from the Atlas Mountains region.",
        "email": "info@atlasartisans.com",
        "telephone": "+212 600-000002",
        "adresse": "Ifrane, Morocco",
        "products_count": 18,
        "licence": "LIC-789123",
        'statut_verification': true,
        'date_creation': now.toString(),
        'derniere_connexion': now.toString(),
        'confirmed': true,
        "images": ["https://picsum.photos/400/300"],
      },
      {
        "cooperative_id": "3",
        "brand": "Sahara Textiles",
        "description": "Traditional Berber textiles and weaving techniques.",
        "email": "weave@sahuratextiles.com",
        "telephone": "+212 600-000003",
        "adresse": "Ouarzazate, Morocco",
        "products_count": 32,
        "licence": "LIC-789123",
        'statut_verification': true,
        'date_creation': now.toString(),
        'derniere_connexion': now.toString(),
        'confirmed': true,
        "images": ["https://picsum.photos/400/300"],
      },
      {
        "cooperative_id": "4",
        "brand": "Mediterranean Flavors",
        "description": "Organic food products from the Mediterranean region.",
        "email": "orders@medflavors.com",
        "telephone": "+212 600-000004",
        "adresse": "Tangier, Morocco",
        "products_count": 15,
        "licence": "LIC-789123",
        "date_creation": "2019",
        "images": ["https://picsum.photos/400/300"],
      },
      {
        "cooperative_id": "5",
        "brand": "Blue City Crafts",
        "description":
            "Artisanal products inspired by the blue city of Chefchaouen.",
        "email": "crafts@bluecity.com",
        "telephone": "+212 600-000005",
        "adresse": "Chefchaouen, Morocco",
        "products_count": 28,
        "licence": "LIC-789123",
        'statut_verification': true,
        'date_creation': now.toString(),
        'derniere_connexion': now.toString(),
        'confirmed': true,
        "images": ["https://picsum.photos/400/300"],
      },
    ];
  }
}
