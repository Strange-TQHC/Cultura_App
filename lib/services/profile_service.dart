import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      ///Android Emulator
      // Uri.parse('http://10.0.2.2:8000/api/profile/'),
      ///Isha
      //Uri.parse('http://172.30.143.154:8000/api/profile/'),
      ///JioFiber
      Uri.parse('http://192.168.29.97:8000/api/profile/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  static Future<List<dynamic>> getMyContributions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      ///Android Emulator
      // Uri.parse('http://10.0.2.2:8000/api/my-contributions/'),
      ///Isha
      //Uri.parse('http://172.30.143.154:8000/api/my-contributions/'),
      ///JioFiber
      Uri.parse('http://192.168.29.97:8000/api/my-contributions/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
}