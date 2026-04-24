import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../local/local_home_screen.dart';
import '../traveler/traveler_home_screen.dart';


class PostLoginScreen extends StatefulWidget {
  final String permanentLocation;

  const PostLoginScreen({super.key, required this.permanentLocation});

  @override
  State<PostLoginScreen> createState() => _PostLoginScreenState();
}

class _PostLoginScreenState extends State<PostLoginScreen> {
  String statusText = "Checking location...";
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    determineMode();
  }

  Future<void> determineMode() async {
    // Step 1: Get current GPS
    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Step 2: Convert permanent location → coordinates
    List<Location> locations =
    await locationFromAddress(widget.permanentLocation);

    double permLat = locations[0].latitude;
    double permLng = locations[0].longitude;

    // Step 3: Calculate distance
    double distance = Geolocator.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      permLat,
      permLng,
    );

    // Step 4: Navigate based on result
    if (distance < 50000) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LocalHomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TravelerHomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CULTURA'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}