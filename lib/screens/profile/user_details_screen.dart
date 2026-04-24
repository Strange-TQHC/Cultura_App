import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/post_login_screen.dart';

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
                ///Android Emulator
                // final url = Uri.parse('http://10.0.2.2:8000/api/signup/');
                ///Isha
                //final url = Uri.parse('http://172.30.143.154:8000/api/signup/');
                ///JioFiber
                final url = Uri.parse('http://192.168.29.97:8000/api/signup/');

                final response = await http.post(
                  url,
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    "email": widget.email,
                    "password": "123456",
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