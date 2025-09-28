import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CooperativeDetails {
  static const String baseUrl = 'http://ton-backend.com/api';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  // Test data for cooperative
  static Map<String, dynamic> _getTestCooperative() {
    return {
      'id': 1,
      'brand_name': 'Artisanat Marocain',
      'description':
          'Coopérative spécialisée dans les produits artisanaux traditionnels marocains',
      'address': 'Marrakech, Morocco',
      'email': 'contact@artisanat-marocain.ma',
      'phone': '+212 6 12 34 56 78',
    };
  }

  //test list
  static List<Map<String, dynamic>> _getTestProducts() {
    return [
      {
        "id": 1,
        "nom": "Savon naturel",
        "description": "Savon bio à l'huile d'argan",
        "prix": 25.0,
        "quantite": 100,
        "categorie": "Cosmetics",
        "poids": 0.2,
        "dimensions": "5x5x2 cm",
        "images": ["images/savon1.jpeg", "images/savon2.jpeg"],
      },
      {
        "id": 2,
        "nom": "Huile d'olive",
        "description": "Huile pressée à froid",
        "prix": 70.0,
        "quantite": 50,
        "categorie": "Food",
        "poids": 1.0,
        "dimensions": "10x10x30 cm",
        "images": ["images/huile1.jpeg"],
      },
      {
        "id": 3,
        "nom": "Tapis berbère",
        "description": "Tapis artisanal tissé à la main au Maroc",
        "prix": 320.0,
        "quantite": 20,
        "categorie": "Textiles",
        "poids": 2.5,
        "dimensions": "150x100 cm",
        "images": ["images/tapis.jpeg"],
      },
    ];
  }

  // Get products by cooperative ID
  static Future<List<Map<String, dynamic>>> getProductsByCooperativeId(
    String cooperativeId,
  ) async {
    try {
      final url = Uri.parse(
        '$baseUrl/clients/viewcooperative/$cooperativeId/products',
      );

      final response = await http
          .get(url, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final productsRaw = data['products'];
        if (productsRaw is List) {
          final List<Map<String, dynamic>> products =
              productsRaw.map((product) {
                final p = product as Map<String, dynamic>;
                return {
                  ...p,
                  'images': p['images'] ?? [], // Assure que 'images' existe
                };
              }).toList();

          return products;
        } else {
          return []; // Si 'products' n'est pas une liste
        }
      } else {
        return _getTestProducts(); // Erreur HTTP
      }
    } catch (e) {
      return _getTestProducts(); // Erreur réseau ou parsing
    }
  }

  // Get cooperative information by ID
  static Future<Map<String, dynamic>?> getCooperativeInfo(
    String cooperativeId,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/clients/viewcooperative/$cooperativeId');

      final response = await http
          .get(url, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['cooperative'] ?? _getTestCooperative();
      } else {
        return _getTestCooperative(); // Erreur HTTP
      }
    } catch (e) {
      return _getTestCooperative(); // Erreur réseau ou parsing
    }
  }
}
