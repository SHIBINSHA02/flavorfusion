import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to get recipe data from a dish using userId and dishId
  static Future<Map<String, dynamic>?> getRecipe(
      String userId, String dishId) async {
    try {
      DocumentSnapshot dishDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dishes')
          .doc(dishId)
          .get();

      if (dishDoc.exists) {
        final data = dishDoc.data() as Map<String, dynamic>?;
        return data?['recipe'] as Map<String, dynamic>?;
      } else {
        return null; // Dish not found
      }
    } catch (e) {
      print('Error getting recipe: $e');
      return null;
    }
  }

  // Function to get rating from a dish using userId and dishId
  static Future<double?> getRating(String userId, String dishId) async {
    try {
      DocumentSnapshot dishDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dishes')
          .doc(dishId)
          .get();

      if (dishDoc.exists) {
        final data = dishDoc.data() as Map<String, dynamic>?;
        return (data?['rating'] as num?)?.toDouble();
      } else {
        return null; // Dish not found
      }
    } catch (e) {
      print('Error getting rating: $e');
      return null;
    }
  }
}
