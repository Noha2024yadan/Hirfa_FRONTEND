import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthCooperative {
  static const String baseUrl =
      'http://@ip:8000/api/cooperative/auth'; // à adapter
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  //Register pour cooperative
  static Future<String?> registerCooperative({
    required String brand_name,
    required String description,
    required String address,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'brand': brand_name,
        'description': description,
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

  //Login for cooperative
  static Future<String?> loginCooperative({
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

  // Forgot Password for Cooperative
  static Future<String?> forgotPasswordCooperative({
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return null; // success
    } else {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Unknown error occurred';
    }
  }

  // Reset Password for Cooperative
  static Future<String?> resetPasswordCooperative({
    required String token,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/auth/cooperative/reset-password');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'password': newPassword}),
    );

    if (response.statusCode == 200) {
      return null; // success
    } else {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Unknown error occurred';
    }
  }
}
