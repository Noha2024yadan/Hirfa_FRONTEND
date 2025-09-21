import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthClient {
  static const String baseUrl =
      'http://ton-backend.com/api/client/auth'; // à adapter
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  //Register pour designer
  static Future<String?> registerClient({
    required String firstName,
    required String lastName,
    required String address,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': firstName,
        'prenom': lastName,
        'adresse': address,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return null; // succès
    } else {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Erreur inconnue';
    }
  }

  //Login for designer
  static Future<String?> loginClient({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      if (token != null) {
        await _storage.write(key: 'jwt_token', value: token);
        return null; // succès
      } else {
        return "Jeton non reçu.";
      }
    } else {
      final data = jsonDecode(response.body);
      // ici si backend envoyé "message": "Veuillez confirmer votre email avant de vous connecter." ce message sera affiché
      return data['message'] ?? "Erreur de connexion.";
    }
  }
}
