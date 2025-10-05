import 'dart:convert';
import 'package:http/http.dart' as http;

class DesignsService {
  static const String baseUrl = 'http://ton-backend.com/api';
  //Report a deisgn
  static Future<bool> reportDesign({
    required String designId,
    required String reason,
  }) async {
    final url = Uri.parse('$baseUrl/design/report');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'designId': designId, 'reason': reason}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Erreur lors du signalement: ${response.body}');
      return false;
    }
  }
}
