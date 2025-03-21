import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

Future<void> uploadDishes(String userId) async {
  if (userId.isEmpty) {
    print("No user is currently signed in.");
    return;
  }

  // Load the JSON file
  final jsonString =
      await rootBundle.rootBundle.loadString('lib/Shopping/dishes.json');
  final List<dynamic> dishes = json.decode(jsonString);

  // Reference to Firestore
  final firestore = FirebaseFirestore.instance;

  // Create a collection under the userId
  final collectionRef =
      firestore.collection('users').doc(userId).collection('shopping');

  // Upload each dish to Firestore using the dish name as the document ID
  for (var dish in dishes) {
    String dishName = dish['name']; // Get the name of the dish
    await collectionRef
        .doc(dishName)
        .set(dish); // Use the dish name as the document ID
  }
}

Future<List<Map<String, dynamic>>> retrieveDishes(String userId) async {
  if (userId.isEmpty) {
    print("No user is currently signed in.");
    return []; // Return an empty list if no user is signed in
  }

  try {
    final firestore = FirebaseFirestore.instance;
    final collectionRef =
        firestore.collection('users').doc(userId).collection('shopping');

    final querySnapshot = await collectionRef.get();
    List<Map<String, dynamic>> dishes = [];

    for (var doc in querySnapshot.docs) {
      dishes.add(doc.data()); // Add document data to the list
    }

    return dishes;
  } catch (e) {
    print("Error retrieving dishes: $e");
    return []; // Return an empty list if there's an error
  }
}