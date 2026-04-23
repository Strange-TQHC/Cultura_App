import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static Future<String> getDescription(
      String name,
      String type,
      List contributions,) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/ai-description/'),
        // Uri.parse('http://172.30.143.154:8000/api/ai-description/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'type': type,
          'contributions': contributions,
        }),
      ).timeout(const Duration(seconds: 90));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['description'];
      } else {
        return "Failed to load description";
      }
    } catch (e) {
      return "Request timed out or failed: $e";
    }
  }
}