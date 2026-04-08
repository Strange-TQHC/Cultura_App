import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    double lat = position.latitude;
    double lon = position.longitude;

    setState(() {
      locationText = "Lat: $lat, Lng: $lon";
    });

    await getWeather(lat, lon);
  }

  Future<void> getWeather(double lat, double lon) async {
    const apiKey = "e5f168beaa4a34e8b14076bdf59bbf28";

    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      double temp = data['main']['temp'];
      String condition = data['weather'][0]['main'];

      setState(() {
        weatherText = "$temp°C, $condition";
      });
    } else {
      setState(() {
        weatherText = "Failed to load weather";
      });
    }
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

            ElevatedButton(
              onPressed: () {},
              child: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

