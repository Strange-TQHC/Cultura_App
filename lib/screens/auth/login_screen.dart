import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'post_login_screen.dart';

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
                ///Android Emulator
                // final url = Uri.parse('http://10.0.2.2:8000/api/login/');
                ///Isha
                //final url = Uri.parse('http://172.30.143.154:8000/api/login/');
                ///JioFiber
                final url = Uri.parse('http://192.168.29.97:8000/api/login/');

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
