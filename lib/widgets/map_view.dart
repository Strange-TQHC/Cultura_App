import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatelessWidget {
  final double lat;
  final double lon;

  final List<Map<String, dynamic>> places;

  const MapView({
    super.key,
    required this.lat,
    required this.lon,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat, lon),
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.cultura_app',
            tileDisplay: const TileDisplay.fadeIn(),
          ),
          MarkerLayer(
            markers: [
              // USER LOCATION
              Marker(
                point: LatLng(lat, lon),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),

              // PLACES
              ...places.map((place) {
                return Marker(
                  point: LatLng(place['lat'], place['lon']),
                  width: 30,
                  height: 30,
                  child: const Icon(
                    Icons.place,
                    color: Colors.blue,
                    size: 30,
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}