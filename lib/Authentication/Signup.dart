// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  void signup() {
    // Placeholder for sign-up logic
    // Implement your custom sign-up logic here
    print("Sign up logic goes here");

    // For demonstration, we will just pop the context
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Create an Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // Sign Up button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    signup();
                  },
                  child: const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 20),
              // Google Sign-Up button
              ElevatedButton(
                onPressed: () async {
                  // Google sign-up functionality removed
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/google.svg', // Ensure this path is correct
                      height: 24, // Adjust height as needed
                    ),
                    const SizedBox(width: 8),
                    const Text('Sign up with Google'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
