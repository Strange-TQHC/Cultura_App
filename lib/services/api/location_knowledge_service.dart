import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationKnowledgeService {
  static Future<Map<String, dynamic>?> getKnowledge(String city) async {
    final response = await http.get(
      ///Android Emulator
      //Uri.parse('http://10.0.2.2:8000/api/location-knowledge/?city=$city'),
      ///Isha
      //Uri.parse('http://172.30.143.154:8000/api/location-knowledge/?city=$city'),
      ///JioFiber
      Uri.parse('http://192.168.29.97:8000/api/location-knowledge/?city=$city'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}