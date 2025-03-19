import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DishService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to add a dish inside the user's 'dishes' subcollection
  static Future<String> addDish(String dishName, String category) async {
    try {
      String? userId = _auth.currentUser?.uid; // Get the current user's ID
      if (userId == null) throw Exception("User not authenticated");

      DocumentReference dishDocRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dishes')
          .add({
        'dishName': dishName,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return dishDocRef.id; // Return the dish ID
    } catch (e) {
      print('Error adding dish: $e');
      return "";
    }
  }

  // Function to add properties to a dish inside the user's 'dishes' subcollection
  static Future<void> addDishProperties(
      String dishId, double rating, String notes) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not authenticated");

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('dishes')
          .doc(dishId)
          .collection('dishProperties')
          .add({
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
        'notes': notes,
      });
    } catch (e) {
      print('Error adding dish properties: $e');
    }
  }

  // Function to add a recipe to a dish inside the user's 'dishes' subcollection
  static Future<void> addRecipe(
      String dishId, Map<String, dynamic> recipeData) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not authenticated");

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('dishes')
          .doc(dishId)
          .collection('recipe')
          .add(recipeData);
    } catch (e) {
      print('Error adding recipe: $e');
    }
  }
}
