import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesService {
  static Future<List<Map<String, dynamic>>> getNearbyPlaces(
      double lat, double lon) async {

    final query = """
    [out:json];
    node
      (around:1000,$lat,$lon)
      ["amenity"];
    out;
    """;

    final url = Uri.parse("https://overpass-api.de/api/interpreter");

    final response = await http.post(
      url,
      body: query,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List elements = data['elements'];

      return elements.map((e) {
        return {
          "name": e['tags']?['name'] ?? "Unknown",
          "lat": e['lat'],
          "lon": e['lon'],
        };
      }).toList();
    } else {
      return [];
    }
  }
}