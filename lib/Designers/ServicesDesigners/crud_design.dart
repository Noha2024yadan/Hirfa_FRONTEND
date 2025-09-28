import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CrudDesign {
  static const String baseUrl = 'http://ton-backend.com/api';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  //test list
  static List<Map<String, dynamic>> _getTestDesigns() {
    return [
      {
        "design_id": 1,
        "nom_design": "Eco Kraft Wrap",
        "description":
            "Biodegradable kraft paper wrap with jute string and recycled label.",
        "prix": 15.0,
        "statut": true,
        "images": ["images/kraft.jpeg"],
      },
      {
        "design_id": 2,
        "nom_design": "Cotton Pouch",
        "description":
            "Soft organic cotton pouch with printed tag, ideal for textiles and accessories.",
        "prix": 22.0,
        "statut": false,
        "images": ["images/pouch.jpeg"],
      },

      {
        "design_id": 3,
        "nom_design": "Rigid Art Box",
        "description":
            "Sturdy cardboard box lined with silk paper, perfect for fragile wall art.",
        "prix": 35.0,
        "statut": true,
        "images": ["images/box.jpeg"],
      },
    ];
  }

  //add design
  static Future addDesign({
    required String nom_design,
    required String description,
    required double prix,
    required bool statut,
    required List<XFile> images,
  }) async {
    final token = await _storage.read(key: 'jwt_token');

    if (token == null) {
      return 'No authentication token found';
    }
    final url = Uri.parse('$baseUrl/designer/addDesign');
    final request =
        http.MultipartRequest('POST', url)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['nom_design'] = nom_design
          ..fields['description'] = description
          ..fields['statut'] = statut.toString();
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

  // Get designs
  static Future<List<Map<String, dynamic>>> getDesigns() async {
    try {
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        return _getTestDesigns(); // Mode test si pas de token
      }

      final url = Uri.parse('$baseUrl/designer/designs');

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

        final designsRaw = data['designs'];
        if (designsRaw is List) {
          final List<Map<String, dynamic>> designs =
              designsRaw.map((design) {
                final d = design as Map<String, dynamic>;
                return {
                  ...d,
                  'images': d['images'] ?? [], // Assure que 'images' existe
                };
              }).toList();

          return designs;
        } else {
          return []; // Si 'products' n'est pas une liste
        }
      } else {
        return _getTestDesigns(); // Erreur HTTP
      }
    } catch (e) {
      return _getTestDesigns(); // Erreur réseau ou parsing
    }
  }

  // delete design
  static Future<String?> deleteDesign(String designId) async {
    try {
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        return "Authentication token not found.";
      }

      final url = Uri.parse('$baseUrl/cooperative/deleteProduct/$designId');

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
        return data['message'] ?? "Failed to delete design.";
      }
    } catch (e) {
      return "Network or server error.";
    }
  }

  //Update design
  static Future<String?> updateDesign({
    required String designId,
    required String nom_design,
    required String description,
    required double prix,
    required bool statut,
    required List<XFile> images,
  }) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        return "Authentication token not found.";
      }

      final url = Uri.parse('$baseUrl/designer/updateDesign/$designId');
      final request =
          http.MultipartRequest('PUT', url)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['nom_design'] = nom_design
            ..fields['description'] = description
            ..fields['prix'] = prix.toString()
            ..fields['statut'] = statut.toString();
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
        return data['message'] ?? "Failed to update design.";
      }
    } catch (e) {
      return "Network or server error.";
    }
  }
}
