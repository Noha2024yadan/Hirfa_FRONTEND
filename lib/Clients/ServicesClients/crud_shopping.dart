import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class CrudShopping {
  static const String baseUrl = 'http://ton-backend.com/api';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static List<Map<String, dynamic>> testPanierList = [
    {
      'panier_item_id': 1,
      'nom_produit': 'Organic Argan Oil',
      'image': 'https://example.com/images/argan_oil.jpg',
      'quantite': 1,
      'prix_unitaire': 75.00,
    },
    {
      'panier_item_id': 2,
      'nom_produit': 'Natural Black Soap with Eucalyptus',
      'image': 'https://example.com/images/black_soap.jpg',
      'quantite': 2,
      'prix_unitaire': 35.00,
    },
    {
      'panier_item_id': 3,
      'nom_produit': 'Dried Organic Figs',
      'image': 'https://example.com/images/dried_figs.jpg',
      'quantite': 1,
      'prix_unitaire': 45.00,
    },
    {
      'panier_item_id': 4,
      'nom_produit': 'Pure Honey from Mountain Cooperative',
      'image': 'https://example.com/images/mountain_honey.jpg',
      'quantite': 1,
      'prix_unitaire': 60.00,
    },
    {
      'panier_item_id': 5,
      'nom_produit': 'Rose Water Facial Mist',
      'image': 'https://example.com/images/rose_water.jpg',
      'quantite': 1,
      'prix_unitaire': 40.00,
    },
    {
      'panier_item_id': 6,
      'nom_produit': 'Olive Oil Soap Bar',
      'image': 'https://example.com/images/olive_soap.jpg',
      'quantite': 3,
      'prix_unitaire': 25.00,
    },
  ];
  //add an item cart
  static Future<bool> addProductToPanier({
    required int productId,
    required int quantity,
    required double unitPrice,
  }) async {
    try {
      // Retrieve JWT token from secure storage
      String? token = await _storage.read(key: 'jwt');
      if (token == null) {
        throw Exception('JWT token not found');
      }

      // Prepare the request payload
      Map<String, dynamic> data = {
        'id_produit': productId,
        'quantite': quantity,
        'prix_unitaire': unitPrice,
      };
      // Send POST request to the backend
      final response = await http.post(
        Uri.parse('$baseUrl/panierItem/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      // Check the response status
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  //get all products
  static Future<List<Map<String, dynamic>>> getPanierProducts() async {
    try {
      String? token = await _storage.read(key: 'jwt');
      if (token == null) {
        return testPanierList;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/panierItem/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }

  //delete panier item
  static Future<bool> deletePanierItem(int panierItemId) async {
    try {
      // Récupérer le token JWT
      String? token = await _storage.read(key: 'jwt');
      if (token == null) {
        throw Exception('JWT token not found');
      }

      // Construire l'URL avec l'ID de l'article
      final url = Uri.parse('$baseUrl/panierItem/delete/$panierItemId');

      // Envoyer la requête DELETE
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Vérifier la réponse
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  //Update item cart
  static Future<bool> updatePanierItemQuantite({
    required int panierItemId,
    required int quantite,
  }) async {
    try {
      // Récupérer le token JWT
      String? token = await _storage.read(key: 'jwt');
      if (token == null) {
        throw Exception('JWT token not found');
      }

      // Préparer les données à envoyer
      Map<String, dynamic> data = {'quantite': quantite};

      // Construire l'URL avec l'ID de l'article
      final url = Uri.parse('$baseUrl/panierItem/update/$panierItemId');

      // Envoyer la requête PUT ou PATCH
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      // Vérifier la réponse
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}
