import 'package:flavorfusion/Presentation/Presentation.dart';
import 'package:flutter/material.dart';
import 'recipe_service.dart'; // Import the RecipeService
import 'dart:convert'; // Import the json library

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                      hintText: 'Enter food name',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    try {
                      // Fetch the recipe
                      final recipe = await RecipeService.generateRecipe(
                          searchController.text);

                      // Print entire JSON response in JSON format
                      print('Generated Recipe: ${json.encode(recipe)}');

                      // Ensure the widget is still mounted before navigating
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PresentationPage(), // Pass the recipe data
                          ),
                        );
                      }
                    } catch (e) {
                      // Print error message
                      print('Error generating recipe: $e');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
