// class DishService {
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   static final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Existing methods
//   static Future<String> addDish(String dishName) async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null) {
//         throw Exception('User not authenticated');
//       }
      
//       final docRef = await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('dishes')
//           .add({
//         'dishName': dishName,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
      
//       return docRef.id;
//     } catch (e) {
//       print('Error adding dish: $e');
//       return '';
//     }
//   }

//   static Future<void> addRecipe(String dishId, Map<String, dynamic> recipeData) async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null) {
//         throw Exception('User not authenticated');
//       }
      
//       await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('dishes')
//           .doc(dishId)
//           .set(
//             {'recipe': recipeData},
//             SetOptions(merge: true),
//           );
//     } catch (e) {
//       print('Error adding recipe: $e');
//       rethrow;
//     }
//   }

//   // New method to add a favorite
//   static Future<void> addFavorite(String recipeName, String dishId) async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null) {
//         throw Exception('User not authenticated');
//       }
      
//       await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('favorites')
//           .doc(recipeName)  // Using recipeName as document ID
//           .set({
//         'dishId': dishId,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error adding favorite: $e');
//       rethrow;
//     }
//   }
// }