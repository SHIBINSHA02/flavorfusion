import 'package:flutter/material.dart';
import 'dart:math' as math; // Import math library for min function

class IngredientsCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String quantity;

  const IngredientsCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final imageHeight = math.min(screenSize.height * 3 / 5, 400.0); // Limit to 400.0

    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                child: Image.network(
                  imageUrl,
                  height: imageHeight,
                  width: double.infinity, // Take full width of card
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Quantity: $quantity',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}