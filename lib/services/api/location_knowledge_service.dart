import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class LocationKnowledgeService {
  static Future<Map<String, dynamic>?> getKnowledge(String city) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/location-knowledge/?city=$city'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}