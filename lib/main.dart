import 'package:flavorfusion/Authentication/auth.dart';
import 'package:flavorfusion/Home/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Authentication/Login.dart';
import 'Authentication/Signup.dart';
import 'Home/navbar.dart';
// import 'package:flavorfusion/Fetch/DB_shopping.dart';
// import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );




  // final userId = FirebaseAuth.instance.currentUser?.uid;

  // if (userId != null) {
  //   // Call uploadDishes with the userId
  //   retrieveDishes(userId).then((dishes) {
  // if (dishes.isNotEmpty) {
  //   print("Retrieved dishes:");
  //   for (var dish in dishes) {
  //     print(dish); // Print each dish (a map)
  //   }
  // } else {
  //   print("No dishes found or an error occurred.");
  // }
  // });
  // } else {
  //   print("No user is currently signed in.");
  // }




  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthPage(), // Ensure this matches the class name
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/signup': (context) => SignUpPage(),
        '/navbar': (context) => NavigationPage(),
      },
    );
  }
}
