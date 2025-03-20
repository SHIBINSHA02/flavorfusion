import 'package:flutter/material.dart';
import 'start_card.dart';
import 'recipe_details_page.dart';

class PresentationPage extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  PresentationPage({required this.recipeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Remove the title from the AppBar
        // title: Text(recipeData['recipe_name'] ?? 'Recipe'), // Default title if null
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding for better layout
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Use the StartCard widget
              StartCard(
                title: recipeData['recipe_name'] ?? 'Recipe', // Pass the title to StartCard
                imageUrl: recipeData['image_url'] ?? 'https://via.placeholder.com/200', // Recipe image
                description: recipeData['description'] ?? 'No description available.', // Recipe description
                totalTime: recipeData['total_time'] ?? 'N/A', // Total time
                onStart: () {
                  // Navigate to the RecipeDetailsPage when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailsPage(recipeData: recipeData),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}