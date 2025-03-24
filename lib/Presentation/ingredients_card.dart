import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

class IngredientsCard extends StatelessWidget {
  final String name;  // Reinstated ingredient name
  final String imageUrl;
  final String quantity;
  final VoidCallback onContinue;

  const IngredientsCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.onContinue,
  }) : super(key: key);

  Future<void> _addToCartAndContinue(BuildContext context) async {
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
          .doc();  // No recipeName needed here, using auto-generated ID

      final doc = await shoppingRef.get();

      if (doc.exists) {
        await shoppingRef.update({
          'ingredients': FieldValue.arrayUnion([
            {'name': name, 'quantity': quantity, 'checked': false}
          ]),
        });
      } else {
        await shoppingRef.set({
          'ingredients': [
            {'name': name, 'quantity': quantity, 'checked': false}
          ],
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingredient added to cart.'),
          backgroundColor: Colors.black87,
        ),
      );
      onContinue();
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart: $e'),
          backgroundColor: Colors.black87,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(color: Colors.orange, width: 2),
        ),
        child: Container(
          width: 350,
          height: 600,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return SizedBox(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: Colors.orange,
                          ),
                        ),
                      );
                    },
                    errorBuilder:
                        (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return SizedBox(
                        height: 250,
                        child: Center(
                          child: Text(
                            'Image could not be loaded',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,  // Display ingredient name
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Quantity: $quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.orange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _addToCartAndContinue(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Add & Continue'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.black87),
                      ),
                    ),
                    child: const Text('Cancel'),
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