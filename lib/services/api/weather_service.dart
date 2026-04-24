import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = "e5f168beaa4a34e8b14076bdf59bbf28";

  static Future<String> getWeather(double lat, double lon) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      double temp = data['main']['temp'];
      String condition = data['weather'][0]['main'];

      return "$temp°C, $condition";
    } else {
      return "Failed to load weather";
    }
  }
}