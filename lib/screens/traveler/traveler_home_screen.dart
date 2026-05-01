import 'package:flutter/material.dart';
import '../../services/location/location_service.dart';
import '../../widgets/map/map_view.dart';
import '../../services/api/places_service.dart';
import '../../services/ai/ai_service.dart';
import '../../services/ai/tts_service.dart';
import '../../services/api/contribution_service.dart';
import '../../services/api/place_match_service.dart';
import 'add_contribution_screen.dart';
import '../profile/profile_screen.dart';
import '../../services/api/weather_service.dart';
import 'package:geocoding/geocoding.dart';
import '../../services/api/location_knowledge_service.dart';
import 'history_screen.dart';
import 'food_screen.dart';
import 'language_screen.dart';
import 'dart:ui';

class TravelerHomeScreen extends StatefulWidget {
  const TravelerHomeScreen({super.key});

  @override
  State<TravelerHomeScreen> createState() => _TravelerHomeScreenState();
}

class _TravelerHomeScreenState extends State<TravelerHomeScreen> {
  String locationText = "Fetching location...";
  String weatherText = "Fetching weather...";

  double? lat;
  double? lon;

  double? selectedLat;
  double? selectedLon;

  Map<String, dynamic>? selectedPlace;

  Map<String, dynamic>? knowledge;
  String? locationImage;

  String? aiDescription;
  bool isLoadingAI = false;

  List<Map<String, dynamic>> places = [];

  List contributions = [];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  Future<void> loadLocation() async {
    final position = await LocationService.getCurrentLocation();

    double latValue = position.latitude;
    double lonValue = position.longitude;

    final placemarks =
    await placemarkFromCoordinates(latValue, lonValue);

    String cityName = placemarks.first.locality ?? "Unknown";

    final fetchedPlaces =
    await PlacesService.getNearbyPlaces(latValue, lonValue);

    final weather =
    await WeatherService.getWeather(latValue, lonValue);

    setState(() {
      lat = latValue;
      lon = lonValue;
      places = fetchedPlaces;

      locationText = cityName;
      weatherText = weather;
    });

    loadLocationKnowledge(cityName);
  }

  Future<void> loadLocationKnowledge(String city) async {
    final data =
    await LocationKnowledgeService.getKnowledge(city);

    setState(() {
      knowledge = data;
      locationImage = data?['image_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 7),
              Text(
                'Cultura',
                style: TextStyle(
                  fontFamily: 'Cultura Font',
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                  letterSpacing: 1.2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'TRAVELER MODE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3.5,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
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
          ]
      ),
      body: getCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_edu),
            label: "Culture",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Food",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            label: "Language",
          ),
        ],
      ),
    );
  }

  Widget _buildTopCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: locationImage != null && locationImage!.isNotEmpty
            ? DecorationImage(
          image: NetworkImage(locationImage!),
          fit: BoxFit.cover,
        )
            : null,
        gradient: locationImage == null || locationImage!.isEmpty
            ? const LinearGradient(
          colors: [
            Colors.teal,
            Colors.transparent,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        )
            : null,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.3), // overlay
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: const [
                Icon(Icons.location_on_outlined, color: Colors.white),
                SizedBox(width: 5),
                Text(
                  "CURRENT LOCATION",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Text(
              locationText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                _buildCapsule(
                  Icons.wb_sunny,
                  weatherText,
                ),
                const SizedBox(width: 10),
                _buildCapsule(
                  Icons.access_time,
                  TimeOfDay.now().format(context),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCapsule(IconData icon, String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 0.25,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 5),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExploreScreen() {
    return SingleChildScrollView(
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
                            await ContributionService.getContributions(
                                placeId);

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

                        const SizedBox(height: 15),

                        ElevatedButton(
                          onPressed: selectedPlace == null
                              ? null
                              : () async {
                            final placeId =
                            await PlaceMatchService.findPlaceId(
                                selectedPlace!['name']);

                            if (placeId != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddContributionScreen(placeId: placeId),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getCurrentScreen() {
    if (selectedIndex == 0) {
      return _buildExploreScreen();
    } else if (selectedIndex == 1) {
      return HistoryScreen(knowledge: knowledge);
    } else if (selectedIndex == 2) {
      return FoodScreen(knowledge: knowledge);
    } else {
      return LanguageScreen(knowledge: knowledge);
    }
  }
}