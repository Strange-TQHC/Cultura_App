import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesService {
  static const String _apiKey = "a0c510c8068d450cbc92925369890ddd";

  static Future<List<Map<String, dynamic>>> getNearbyPlaces(
      double lat, double lon) async {

    const String categories = "catering,entertainment,leisure,tourism";
    const int radiusInMeters = 2000;

    final url = Uri.parse(
        "https://api.geoapify.com/v2/places?"
            "categories=$categories&"
            "filter=circle:$lon,$lat,$radiusInMeters&"
            "bias=proximity:$lon,$lat&"
            "limit=20&"
            "apiKey=$_apiKey"
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List features = data['features'];

        return features.map((feature) {
          final properties = feature['properties'];
          return {
            "name": properties['name'] ?? "Unknown",
            "lat": properties['lat'],
            "lon": properties['lon'],
            "type": properties['categories']?[0] ?? "unknown",
          };
        }).toList();
      } else {
        print("Geoapify Error: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Request Exception: $e");
      return [];
    }
  }
}