import 'package:flutter/material.dart';
import 'start_card.dart';
import 'recipe_details_page.dart';

class PresentationPage extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  const PresentationPage({super.key, required this.recipeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StartCard(
                  title: recipeData['recipe_name'] ?? 'Recipe',
                  imageUrl: recipeData['image_url'] ??
                      'https://via.placeholder.com/200',
                  description:
                      recipeData['description'] ?? 'No description available.',
                  totalTime: recipeData['total_time'] ?? 'N/A',
                  onStart: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailsPage(recipeData: recipeData),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
