import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  final double lat;
  final double lon;

  final List<Map<String, dynamic>> places;

  final double? selectedLat;
  final double? selectedLon;

  const MapView({
    super.key,
    required this.lat,
    required this.lon,
    required this.places,
    this.selectedLat,
    this.selectedLon,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedLat != null && widget.selectedLon != null) {
      _mapController.move(
        LatLng(widget.selectedLat!, widget.selectedLon!),
        16,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(widget.lat, widget.lon),
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
                point: LatLng(widget.lat, widget.lon),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),

              // PLACES
              ...widget.places.map((place) {
                final isSelected =
                    place['lat'] == widget.selectedLat &&
                        place['lon'] == widget.selectedLon;

                return Marker(
                  point: LatLng(place['lat'], place['lon']),
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.place,
                    color: isSelected ? Colors.green : Colors.blue,
                    size: isSelected ? 40 : 30,
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