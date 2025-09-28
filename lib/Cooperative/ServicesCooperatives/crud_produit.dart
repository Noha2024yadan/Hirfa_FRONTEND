import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CrudProduit {
  static const String baseUrl = 'http://ton-backend.com/api';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
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

  //product add for cooperative
  static Future addProduct({
    required String nom_produit,
    required String description,
    required double prix,
    required int quantite_stock,
    required String categorie,
    required double poids,
    required String dimensions,
    required List<XFile> images,
  }) async {
    final token = await _storage.read(key: 'jwt_token');

    if (token == null) {
      return 'No authentication token found';
    }
    final url = Uri.parse('$baseUrl/cooperative/addProduct');
    final request =
        http.MultipartRequest('POST', url)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['product'] = nom_produit
          ..fields['description'] = description
          ..fields['prix'] = prix.toString()
          ..fields['quantite'] = quantite_stock.toString()
          ..fields['categorie'] = categorie
          ..fields['poids'] = poids.toString()
          ..fields['dimensions'] = dimensions;

    // 🔁 Ajout des images à la requête
    for (var image in images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images', // ou 'images[]' selon ton backend
          image.path,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return null;
    } else {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Erreur inconnue';
    }
  }

  // Get products cooperative
  static Future<List<Map<String, dynamic>>> getProductCooperative() async {
    try {
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        return _getTestProducts(); // Mode test si pas de token
      }

      final url = Uri.parse('$baseUrl/cooperative/products');

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

  // delete cooperative product
  static Future<String?> deleteCooperativeProduct(String productId) async {
    try {
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        return "Authentication token not found.";
      }

      final url = Uri.parse('$baseUrl/cooperative/deleteProduct/$productId');

      final response = await http
          .delete(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return null; // success
      } else {
        final data = jsonDecode(response.body);
        return data['message'] ?? "Failed to delete product.";
      }
    } catch (e) {
      return "Network or server error.";
    }
  }

  //Update cooperative product
  static Future<String?> updateCooperativeProduct({
    required String productId,
    required String nom_produit,
    required String description,
    required double prix,
    required int quantite_stock,
    required String categorie,
    required double poids,
    required String dimensions,
    required List<XFile> images,
  }) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        return "Authentication token not found.";
      }

      final url = Uri.parse('$baseUrl/cooperative/updateProduct/$productId');
      final request =
          http.MultipartRequest('PUT', url)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['product'] = nom_produit
            ..fields['description'] = description
            ..fields['prix'] = prix.toString()
            ..fields['quantite'] = quantite_stock.toString()
            ..fields['categorie'] = categorie
            ..fields['poids'] = poids.toString()
            ..fields['dimensions'] = dimensions;

      // 🔁 Add images to the request
      for (var image in images) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images', // or 'images[]' depending on your backend
            image.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return null;
      } else {
        final data = jsonDecode(response.body);
        return data['message'] ?? "Failed to update product.";
      }
    } catch (e) {
      return "Network or server error.";
    }
  }
}
