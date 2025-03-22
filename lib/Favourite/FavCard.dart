import 'package:flutter/material.dart';

class FavCard extends StatelessWidget {
  final String dishName;
  final String imageUrl;
  final String description;
  final int rating;

  FavCard({
    required this.dishName,
    required this.imageUrl,
    required this.description,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // Main Column
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // Image and (Dishname, Rating)
                children: [
                  ClipOval(
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      // Dishname and Rating
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dishName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          // Rating Stars
                          children: List.generate(5, (index) {
                            return Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                // Description
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
