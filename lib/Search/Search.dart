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

  Future<void> _searchRecipe(BuildContext context) async {
    setState(() {
      isLoading = true; // Show loading screen
    });

    try {
      final recipe = await RecipeService.generateRecipeWithImages(searchController.text);

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
                        onPressed: () => _searchRecipe(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
