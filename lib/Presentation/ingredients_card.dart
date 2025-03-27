import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';

class IngredientsCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String quantity;
  final String recipeName;
  final VoidCallback onContinue;

  const IngredientsCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.recipeName,
    required this.onContinue,
  }) : super(key: key);

  @override
  _IngredientsCardState createState() => _IngredientsCardState();
}

class _IngredientsCardState extends State<IngredientsCard> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speakIngredientDetails();
  }

  void _speakIngredientDetails() async {
    await flutterTts.speak("Ingredient: ${widget.name}");
    await flutterTts.speak("Quantity: ${widget.quantity}");
  }

  void _stopSpeaking() async {
    await flutterTts.stop();
  }

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
          .doc(widget.recipeName);

      final doc = await shoppingRef.get();

      if (doc.exists) {
        await shoppingRef.update({
          'ingredients': FieldValue.arrayUnion([
            {'name': widget.name, 'quantity': widget.quantity, 'checked': false}
          ]),
        });
      } else {
        await shoppingRef.set({
          'ingredients': [
            {'name': widget.name, 'quantity': widget.quantity, 'checked': false}
          ],
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingredient added to cart.'),
          backgroundColor: Colors.black87,
        ),
      );
      _stopSpeaking(); // Stop speaking before continuing
      widget.onContinue();
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
  void didUpdateWidget(IngredientsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the ingredient changes, re-speak the new details
    if (oldWidget.name != widget.name ||
        oldWidget.quantity != widget.quantity) {
      _stopSpeaking().then((_) => _speakIngredientDetails());
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
                    widget.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
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
                    errorBuilder: (context, error, stackTrace) {
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
                        widget.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Quantity: ${widget.quantity}',
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
                    onPressed: () {
                      _stopSpeaking(); // Stop speaking when cancelling
                      Navigator.pop(context);
                    },
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

  @override
  void dispose() {
    _stopSpeaking(); // Clean up TTS when widget is disposed
    super.dispose();
  }
}
