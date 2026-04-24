import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddContributionService {
  static Future<bool> addContribution({
    required int placeId,
    required String category,
    required String content,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      ///Android Emulator
      // Uri.parse('http://10.0.2.2:8000/api/add-contribution/'),
      ///Isha
      //Uri.parse('http://172.30.143.154:8000/api/add-contribution/'),
      ///JioFiber
      Uri.parse('http://192.168.29.97:8000/api/add-contribution/'),

      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: jsonEncode({
        'place_id': placeId,
        'category': category,
        'content': content,
      }),
    );

    return response.statusCode == 200;
  }
}