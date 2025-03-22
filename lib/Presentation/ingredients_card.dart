import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

class IngredientsCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String quantity;
  final String recipeName;

  const IngredientsCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.recipeName,
  }) : super(key: key);

  Future<void> _addToCart(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not signed in.')),
      );
      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;
      final shoppingRef = firestore
          .collection('users')
          .doc(user.uid)
          .collection('shopping')
          .doc(recipeName);

      final doc = await shoppingRef.get();

      if (doc.exists) {
        // Recipe exists, update ingredients
        await shoppingRef.update({
          'ingredients': FieldValue.arrayUnion([
            {'name': name, 'quantity': quantity, 'checked': false}
          ]),
        });
      } else {
        // Recipe doesn't exist, create new document
        await shoppingRef.set({
          'name': recipeName,
          'ingredients': [
            {'name': name, 'quantity': quantity, 'checked': false}
          ],
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingredient added to cart.')),
      );
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final imageHeight = math.min(screenSize.height * 3 / 5, 400.0);

    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12.0)),
                child: Image.network(
                  imageUrl,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                'Quantity: $quantity',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                'Recipe: $recipeName',
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _addToCart(context),
                    child: const Text('Add to Cart'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Continue button goes back
                    },
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}