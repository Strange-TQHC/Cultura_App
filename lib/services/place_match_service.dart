import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlaceMatchService {
  static Future<int?> findPlaceId(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    ///Android Emulator
    // final url = Uri.parse('http://10.0.2.2:8000/api/find-place/?name=$name');
    ///Isha
    //final url = Uri.parse('http://172.30.143.154:8000/api/find-place/?name=$name');
    ///JioFiber
    final url = Uri.parse('http://192.168.29.97:8000/api/find-place/?name=$name');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      return null;
    }
  }
}