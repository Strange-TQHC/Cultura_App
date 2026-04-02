import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
      home: const HomeScreen(),
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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                /* Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostLoginScreen(),
                  ),
                ); */
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
              onPressed: () {
                print("Name: ${nameController.text}");
                print("Age: ${ageController.text}");
                print("Gender: ${genderController.text}");
                print("Current Location: ${currentLocationController.text}");
                print("Permanent Location: ${permanentLocationController.text}");
                print("Food Preferences: ${foodPreferenceController.text}");

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostLoginScreen(
                      permanentLocation: permanentLocationController.text,
                    ),
                  ),
                );
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

    // Step 4: Decide mode (radius = 50km)
    if (distance < 50000) {
      setState(() {
        statusText = "You're at home (Local Resident Mode)";
      });
    } else {
      setState(() {
        statusText = "You're traveling (Traveler Mode)";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CULTURA'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              statusText,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: determineMode,
              child: const Text('Recheck'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                      (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}