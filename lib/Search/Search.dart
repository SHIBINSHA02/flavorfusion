import 'package:flavorfusion/Presentation/Presentation.dart';
import 'package:flutter/material.dart';
import 'recipe_service.dart';
import 'dart:convert';
import './../Loading/spoon.dart'; // Import the loading screen

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  String _searchType = 'Search Recipe'; // Default search type

  Future<void> _searchRecipe(BuildContext context) async {
    setState(() {
      isLoading = true; // Show loading screen
    });

    try {
      final recipe = await RecipeService.generateRecipeWithImages(
          searchController.text,
          searchType: _searchType); // Pass search type

      final encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(recipe);
      debugPrint('Generated Recipe:\n$prettyJson');

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PresentationPage(recipeData: recipe),
          ),
        ).then((_) {
          // Stop loading when returning from PresentationPage
          setState(() {
            isLoading = false;
          });
        });
      }
    } catch (e) {
      debugPrint('Error generating recipe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        isLoading = false; // Stop loading in case of an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen() // Show loading screen
        : Scaffold(
            appBar: AppBar(
              title: const Text('Search Recipes'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dropdown for search type
                  DropdownButtonFormField<String>(
                    value: _searchType,
                    items: <String>[
                      'Search Recipe',
                      'Create from Ingredients'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _searchType = newValue!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Search',
                            hintText: 'Create from Ingredients',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _searchRecipe(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                        child: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
