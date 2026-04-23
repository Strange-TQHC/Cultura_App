import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../widgets/map_view.dart';
import '../services/places_service.dart';
import '../services/ai_service.dart';
import '../services/tts_service.dart';
import '../services/contribution_service.dart';
import '../services/place_match_service.dart';

class TravelerHomeScreen extends StatefulWidget {
  const TravelerHomeScreen({super.key});

  @override
  State<TravelerHomeScreen> createState() => _TravelerHomeScreenState();
}

class _TravelerHomeScreenState extends State<TravelerHomeScreen> {
  double? lat;
  double? lon;

  double? selectedLat;
  double? selectedLon;

  Map<String, dynamic>? selectedPlace;

  String? aiDescription;
  bool isLoadingAI = false;

  List<Map<String, dynamic>> places = [];

  List contributions = [];

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  Future<void> loadLocation() async {
    final position = await LocationService.getCurrentLocation();

    double latValue = position.latitude;
    double lonValue = position.longitude;

    final fetchedPlaces = await PlacesService.getNearbyPlaces(latValue, lonValue);

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
                      selectedLat: selectedLat,
                      selectedLon: selectedLon,
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

                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              selectedLat = place['lat'];
                              selectedLon = place['lon'];
                              selectedPlace = place;
                              isLoadingAI = true;
                              aiDescription = null;
                              contributions = [];
                            });

                            // Match place with DB
                            final placeId =
                            await PlaceMatchService.findPlaceId(place['name']);

                            if (placeId != null) {
                              // Fetch contributions
                              final fetchedContributions =
                              await ContributionService.getContributions(placeId);

                              // AI with real DB data
                              final desc = await AIService.getDescription(
                                place['name'],
                                place['type'],
                                fetchedContributions,
                              );

                              setState(() {
                                contributions = fetchedContributions;
                                aiDescription = desc;
                                isLoadingAI = false;
                              });
                            } else {
                              // fallback (no DB data)
                              final desc = await AIService.getDescription(
                                place['name'],
                                place['type'],
                                [],
                              );

                              setState(() {
                                aiDescription = desc;
                                isLoadingAI = false;
                              });
                            }
                          },

                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: 140,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.place,
                                    color: (place['lat'] == selectedLat &&
                                        place['lon'] == selectedLon)
                                        ? Colors.green
                                        : Colors.blue,
                                  ),
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
                          ),
                        );
                      },
                    ),
                  ),

                  //Detail Panel UI
                  const SizedBox(height: 20),

                  selectedPlace == null
                      ? const Text("Select a place to see details")
                      : Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedPlace!['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text("Type: ${selectedPlace!['type']}"),

                          const SizedBox(height: 10),

                          Text(
                            "Location: ${selectedPlace!['lat']}, ${selectedPlace!['lon']}",
                          ),

                          const SizedBox(height: 10),

                          isLoadingAI
                              ? const CircularProgressIndicator()
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(aiDescription ?? "No description"),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: aiDescription == null
                                        ? null
                                        : () {
                                      TTSService.speak(aiDescription!);
                                    },
                                    icon: const Icon(Icons.volume_up),
                                    label: const Text("Read Aloud"),
                                  ),

                                  const SizedBox(width: 10),

                                  ElevatedButton.icon(
                                    onPressed: () {
                                      TTSService.stop();
                                    },
                                    icon: const Icon(Icons.stop),
                                    label: const Text("Stop"),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            "Local Insights:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          ...contributions.map((c) {
                            return Text("- ${c['content']}");
                          }).toList(),
                        ],
                      ),
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