import 'package:flutter/material.dart';
import '../../services/location/location_service.dart';
import '../../services/api/weather_service.dart';
import '../profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/home_screen.dart';
import '../../widgets/map/map_view.dart';
import '../../services/api/places_service.dart';
import '../../services/ai/ai_service.dart';
import '../../services/ai/tts_service.dart';
import '../../services/api/contribution_service.dart';
import '../../services/api/place_match_service.dart';
import '../traveler/add_contribution_screen.dart';

class LocalHomeScreen extends StatefulWidget {
  const LocalHomeScreen({super.key});

  @override
  State<LocalHomeScreen> createState() => _LocalHomeScreenState();
}

class _LocalHomeScreenState extends State<LocalHomeScreen> {
  String locationText = "Fetching location...";
  String weatherText = "Fetching weather...";

  double? lat;
  double? lon;

  List<Map<String, dynamic>> places = [];

  double? selectedLat;
  double? selectedLon;
  Map<String, dynamic>? selectedPlace;

  String? aiDescription;
  bool isLoadingAI = false;

  List contributions = [];

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    final position = await LocationService.getCurrentLocation();

    double latValue = position.latitude;
    double lonValue = position.longitude;

    final weather = await WeatherService.getWeather(latValue, lonValue);
    final fetchedPlaces =
    await PlacesService.getNearbyPlaces(latValue, lonValue);

    setState(() {
      lat = latValue;
      lon = lonValue;
      locationText = "Lat: $latValue, Lng: $lonValue";
      weatherText = weather;
      places = fetchedPlaces;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CULTURA - Home'),
        automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ),
                      (route) => false,
                );
              },
            ),
          ]
      ),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "You're at home",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // TOP INFO CARD
            _buildTopCard(),

            const SizedBox(height: 20),

            lat == null
                ? const CircularProgressIndicator()
                : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Explore Your Hometown",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

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
                            contributions = [];
                          });

                          final placeId =
                          await PlaceMatchService.findPlaceId(place['name']);

                          if (placeId != null) {
                            final fetched =
                            await ContributionService.getContributions(placeId);

                            final desc = await AIService.getDescription(
                              place['name'],
                              place['type'],
                              fetched,
                            );

                            setState(() {
                              contributions = fetched;
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
              ],
            ),
            ),

            const SizedBox(height: 20),

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

                    const SizedBox(height: 15),

                    ///ADD CONTRIBUTION BUTTON
                    ElevatedButton(
                      onPressed: selectedPlace == null
                          ? null
                          : () async {
                        final placeId =
                        await PlaceMatchService.findPlaceId(selectedPlace!['name']);

                        if (placeId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddContributionScreen(placeId: placeId),
                            ),
                          );
                        }
                      },
                      child: const Text("Add Contribution"),
                    ),
                  ],
                ),
              ),
                 ),
          ]
        ),
      ),
    );
  }

  Widget _buildTopCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: const Icon(Icons.location_on),
        title: Text("Current Location"),
        subtitle: Text(locationText),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              TimeOfDay.now().format(context),
            ),
            Text(weatherText),
          ],
        ),
      ),
    );
  }
}

