import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../widgets/map_view.dart';
import '../services/places_service.dart';

class TravelerHomeScreen extends StatefulWidget {
  const TravelerHomeScreen({super.key});

  @override
  State<TravelerHomeScreen> createState() => _TravelerHomeScreenState();
}

class _TravelerHomeScreenState extends State<TravelerHomeScreen> {
  double? lat;
  double? lon;

  List<Map<String, dynamic>> places = [];

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  Future<void> loadLocation() async {
    final position = await LocationService.getCurrentLocation();

    double latValue = position.latitude;
    double lonValue = position.longitude;

    final fetchedPlaces =
    await PlacesService.getNearbyPlaces(latValue, lonValue);

    setState(() {
      lat = latValue;
      lon = lonValue;
      places = fetchedPlaces;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CULTURA - Traveler'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TOP INFO CARD
            _buildTopCard(),

            const SizedBox(height: 20),

            /// Nearby Highlights + OSM
            lat == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nearby Highlights",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // MAP
                  SizedBox(
                    height: 200,
                    child: MapView(
                      lat: lat!,
                      lon: lon!,
                      places: places,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // LIST
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        final place = places[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.place, color: Colors.blue),
                                const SizedBox(height: 10),
                                Text(
                                  place['name'],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            _buildSection("History & Culture"),
            _buildSection("Food & Etiquette"),
            _buildSection("Local Language & Folklores"),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: const Icon(Icons.location_on),
        title: const Text("Current Location"),
        subtitle: const Text("Fetching..."),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Time"),
            Text("Weather"),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 120,
                  alignment: Alignment.center,
                  child: Text("$title\nItem ${index + 1}"),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}