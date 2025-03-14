import 'package:flavorfusion/Presentation/Presentation.dart';
import 'package:flutter/material.dart';
import 'recipe_service.dart';
import 'dart:convert';

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
                      final recipe =
                          await RecipeService.generateRecipeWithImages(
                              searchController.text);

                      final encoder = JsonEncoder.withIndent('  ');
                      final prettyJson = encoder.convert(recipe);
                      print('Generated Recipe:\n$prettyJson');

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PresentationPage(recipe: recipe),
                          ),
                        );
                      }
                    } catch (e) {
                      print('Error generating recipe: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
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