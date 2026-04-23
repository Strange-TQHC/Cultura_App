import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/local_home_screen.dart';
import 'screens/traveler_home_screen.dart';

void main() {
  runApp(const CulturaApp());
}

class CulturaApp extends StatelessWidget {
  const CulturaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CULTURA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const SplashCheckScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CULTURA'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Explore Cultures Around You',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('Login'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignupScreen(),
                  ),
                );
              },
              child: const Text('Signup'),
            ),

            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: () {
                // Guest flow (later)
              },
              child: const Text('Continue as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// LOGIN SCREEN
////////////////////////////////////////////////////////////

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final url = Uri.parse('http://10.0.2.2:8000/api/login/');
                // final url = Uri.parse('http://172.30.143.154:8000/api/login/');

                final response = await http.post(
                  url,
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    "email": emailController.text,
                    "password": passwordController.text,
                  }),
                );

                final data = jsonDecode(response.body);

                if (response.statusCode == 200) {
                  final prefs = await SharedPreferences.getInstance();

                  await prefs.setString('token', data['token']);
                  await prefs.setString('permanent_location', data['permanent_location']);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostLoginScreen(
                        permanentLocation: data['permanent_location'],
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(data['error'] ?? 'Login failed'),
                    ),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// SIGNUP SCREEN (UPDATED)
////////////////////////////////////////////////////////////

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailsScreen(
                        email: emailController.text,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// USER DETAILS SCREEN
////////////////////////////////////////////////////////////

class UserDetailsScreen extends StatefulWidget {
  final String email;

  const UserDetailsScreen({super.key, required this.email});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final currentLocationController = TextEditingController();
  final permanentLocationController = TextEditingController();
  final foodPreferenceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Email: ${widget.email}"),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: genderController,
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: currentLocationController,
              decoration: const InputDecoration(labelText: 'Current Location'),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: permanentLocationController,
              decoration: const InputDecoration(labelText: 'Permanent Location'),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: foodPreferenceController,
              decoration: const InputDecoration(labelText: 'Food Preferences'),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                /// final url = Uri.parse('http://10.0.2.2:8000/api/signup/');
                final url = Uri.parse('http://172.30.143.154:8000/api/signup/');

                final response = await http.post(
                  url,
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    "email": widget.email,
                    "password": "123456", // temporary (we’ll fix later)
                    "name": nameController.text,
                    "age": int.tryParse(ageController.text) ?? 0,
                    "gender": genderController.text,
                    "current_location": currentLocationController.text,
                    "permanent_location": permanentLocationController.text,
                    "food_preferences": foodPreferenceController.text,
                  }),
                );

                if (response.statusCode == 200) {
                  // SUCCESS
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostLoginScreen(
                        permanentLocation: permanentLocationController.text,
                      ),
                    ),
                  );
                } else {
                  // ERROR
                  print(response.body);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Signup failed'),
                    ),
                  );
                }
              },
              child: const Text('Finish'),
            )
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// POST LOGIN SCREEN WITH MODE DETECTION
////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////
/// SPLASH CHECK SCREEN (AUTO LOGIN)
////////////////////////////////////////////////////////////

class SplashCheckScreen extends StatefulWidget {
  const SplashCheckScreen({super.key});

  @override
  State<SplashCheckScreen> createState() => _SplashCheckScreenState();
}

class _SplashCheckScreenState extends State<SplashCheckScreen> {

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final permanentLocation = prefs.getString('permanent_location');

    if (token != null && permanentLocation != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PostLoginScreen(
            permanentLocation: permanentLocation,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}