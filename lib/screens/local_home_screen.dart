import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import 'profile_screen.dart';

class LocalHomeScreen extends StatefulWidget {
  const LocalHomeScreen({super.key});

  @override
  State<LocalHomeScreen> createState() => _LocalHomeScreenState();
}

class _LocalHomeScreenState extends State<LocalHomeScreen> {
  String locationText = "Fetching location...";
  String weatherText = "Fetching weather...";

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    final position = await LocationService.getCurrentLocation();

    double lat = position.latitude;
    double lon = position.longitude;

    setState(() {
      locationText = "Lat: $lat, Lng: $lon";
    });

    final weather = await WeatherService.getWeather(lat, lon);

    setState(() {
      weatherText = weather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CULTURA - Home'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "You're at home",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text("Current Location"),
                subtitle: Text(locationText),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.wb_sunny),
                title: const Text("Weather"),
                subtitle: Text(weatherText),
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {},
              child: const Text('Explore Your Hometown'),
            ),

            const SizedBox(height: 20),

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
          ],
        ),
      ),
    );
  }
}

