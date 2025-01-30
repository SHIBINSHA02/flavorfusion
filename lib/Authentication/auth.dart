import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorfusion/Authentication/Login.dart';
import 'package:flavorfusion/Home/navbar.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Handle error state
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong! Please try again later.'),
            );
          }

          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Handle authenticated state
          if (snapshot.hasData) {
            return const NavigationPage();
          }

          // Handle unauthenticated state
          return const LoginPage();
        },
      ),
    );
  }
}
