import 'package:flutter/material.dart';
import '../../services/location/location_service.dart';
import '../../services/api/weather_service.dart';
import '../profile/profile_screen.dart';
import '../../widgets/map/map_view.dart';
import '../../services/api/places_service.dart';
import '../../services/ai/ai_service.dart';
import '../../services/ai/tts_service.dart';
import '../../services/api/contribution_service.dart';
import '../../services/api/place_match_service.dart';
import '../traveler/add_contribution_screen.dart';
import '../traveler/history_screen.dart';
import '../traveler/food_screen.dart';
import '../traveler/language_screen.dart';
import '../../services/api/location_knowledge_service.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:ui';

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

  int selectedIndex = 0;

  int? currentPlaceId;

  bool isPlaying = false;

  Map<String, dynamic>? knowledge;
  String? locationImage;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    final position = await LocationService.getCurrentLocation();

    double latValue = position.latitude;
    double lonValue = position.longitude;

    final placemarks = await placemarkFromCoordinates(latValue, lonValue);

    String cityName = placemarks.first.locality ?? "Unknown";

    final weather = await WeatherService.getWeather(latValue, lonValue);
    final fetchedPlaces = await PlacesService.getNearbyPlaces(
      latValue,
      lonValue,
    );

    loadLocationKnowledge(cityName);

    setState(() {
      lat = latValue;
      lon = lonValue;
      locationText = cityName;
      weatherText = weather;
      places = fetchedPlaces;
    });
  }

  Future<void> loadLocationKnowledge(String city) async {
    final data = await LocationKnowledgeService.getKnowledge(city);

    setState(() {
      knowledge = data;
      locationImage = data?['image_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              'LOCAL RESIDENT MODE',
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
      ),
      body: getCurrentScreen(),
      bottomNavigationBar: _buildFloatingNavBar(),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home_outlined, Icons.home, 0),
                _navItem(Icons.history_edu_outlined, Icons.history_edu, 1),
                _navItem(Icons.restaurant_outlined, Icons.restaurant, 2),
                _navItem(Icons.language_outlined, Icons.language, 3),
                _navItem(Icons.person_outline, Icons.person, 4), // Profile Item
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, IconData activeIcon, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 4) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        } else {
          setState(() => selectedIndex = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? Colors.blue : Colors.grey[700],
          size: 26,
        ),
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
                colors: [Colors.teal, Colors.transparent],
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
                _buildCapsule(Icons.wb_sunny, weatherText),
                const SizedBox(width: 10),
                _buildCapsule(
                  Icons.access_time,
                  TimeOfDay.now().format(context),
                ),
              ],
            ),
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
      padding: const EdgeInsets.only(bottom: 100), // Space for floating bar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back home,",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const Text(
                  "Explore Your Hometown",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                ),
              ],
            ),
          ),

          _buildTopCard(),

          const SizedBox(height: 20),

          if (lat == null)
            const Center(child: CircularProgressIndicator())
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modern Map View
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      height: 220,
                      child: MapView(
                        lat: lat!,
                        lon: lon!,
                        places: places,
                        selectedLat: selectedLat,
                        selectedLon: selectedLon,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Horizontal Place List
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        final place = places[index];
                        bool isSelected = place['lat'] == selectedLat && place['lon'] == selectedLon;

                        return GestureDetector(
                          onTap: () => _handlePlaceSelection(place),
                          child: Container(
                            width: 150,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: isSelected ? Colors.blue : Colors.blue.withOpacity(0.1),
                                  child: Icon(Icons.place, color: isSelected ? Colors.white : Colors.blue),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  place['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    fontSize: 13,
                                  ),
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

                  const SizedBox(height: 25),
                  if (selectedPlace != null) _buildModernDetailPanel(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // UI Helper: Detail Panel with the Add Contribution Button
  Widget _buildModernDetailPanel() {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedPlace!['name'],
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    selectedPlace!['type'].toString().toUpperCase(),
                    style: const TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            isLoadingAI
                ? const LinearProgressIndicator()
                : Text(aiDescription ?? "Discovering details...", style: TextStyle(color: Colors.grey[800], height: 1.5)),
            const SizedBox(height: 20),
            // AUDIO & CONTRIBUTION CONTROLS
            Row(
              children: [
                // PLAY / PAUSE BUTTON
                GestureDetector(
                  onTap: () {
                    if (aiDescription != null) {
                      setState(() {
                        if (isPlaying) {
                          TTSService.stop();
                          isPlaying = false;
                        } else {
                          TTSService.speak(aiDescription!);
                          isPlaying = true;
                        }
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // STOP BUTTON
                IconButton(
                  onPressed: () {
                    TTSService.stop();
                    setState(() => isPlaying = false);
                  },
                  icon: const Icon(Icons.stop_rounded, color: Colors.redAccent),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                  ),
                ),

                const Spacer(),

                // CONTRIBUTE BUTTON
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
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
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Contribute"),
                ),
              ],
            ),
          ],
        )
    );
  }

  // Abstracted logic for selection
  Future<void> _handlePlaceSelection(Map<String, dynamic> place) async {
    setState(() {
      selectedLat = place['lat'];
      selectedLon = place['lon'];
      selectedPlace = place;
      isLoadingAI = true;
      aiDescription = null;
      contributions = [];
    });

    final placeId = await PlaceMatchService.findPlaceId(place['name']);
    if (placeId != null) {
      final fetched = await ContributionService.getContributions(placeId);
      final desc = await AIService.getDescription(place['name'], place['type'], fetched);
      setState(() {
        contributions = fetched;
        aiDescription = desc;
        isLoadingAI = false;
      });
    }
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
