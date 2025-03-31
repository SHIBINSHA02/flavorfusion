import 'package:flavorfusion/Presentation/Presentation.dart';
import 'package:flutter/material.dart';
import 'recipe_service.dart';
import 'dart:convert';
import './../Loading/spoon.dart'; // Import the loading screen
import 'package:lottie/lottie.dart'; // Import Lottie package

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  String _searchType = 'Search Recipe'; // Default search type
  String _hintText = 'Enter the name of the dish'; // Default hint text
  final Set<String> _selectedIngredients = {}; // Track selected ingredients

  @override
  void initState() {
    super.initState();
    // Set initial hint text based on default search type
    _updateHintText();
  }

  void _updateHintText() {
    setState(() {
      _hintText = _searchType == 'Search Recipe'
          ? 'Enter the name of the dish'
          : 'Enter ingredients';
    });
  }

  void _addIngredient(String ingredient) {
    if (!_selectedIngredients.contains(ingredient)) {
      setState(() {
        _selectedIngredients.add(ingredient);
        // Add the ingredient to the search box with the ingredient followed by a comma
        if (searchController.text.isNotEmpty) {
          searchController.text = '${searchController.text}, $ingredient'; // Comma after the ingredient
        } else {
          searchController.text = '$ingredient'; // No comma for the first ingredient
        }
      });
      print('Added ingredient: $ingredient'); // Debug print
      print('Current search text: ${searchController.text}'); // Debug print
    }
  }

  Future<void> _searchRecipe(BuildContext context) async {
    setState(() {
      isLoading = true; // Show loading screen
    });

    // Check for commas in the search input
    if (_searchType == 'Search Recipe' && searchController.text.contains(',')) {
      setState(() {
        isLoading = false; // Stop loading
      });
      // Show warning dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text('Please use the "Create from Ingredients" option if you are entering ingredients.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Exit the function early
    }

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
      setState(() {
        isLoading = false; // Stop loading in case of an error
      });
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('An error occurred: $e'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
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
                    items: <String>['Search Recipe', 'Create from Ingredients']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _searchType = newValue!;
                        _updateHintText(); // Update hint text based on search type
                        _selectedIngredients.clear(); // Reset selected ingredients
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
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Search',
                            hintText: _hintText, // Use dynamic hint text
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

                  // Ingredient Buttons (only visible for "Create from Ingredients")
                  if (_searchType == 'Create from Ingredients') ...[
                    const SizedBox(height: 16),
                    Text(
                      'Quick Add Ingredients:',
                      style: Theme.of(context).textTheme.titleLarge, // Original style
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0, // Space between buttons
                      runSpacing: 8.0, // Space between rows
                      children: [
                        ElevatedButton(
                          onPressed: () => _addIngredient('Salt'),
                          child: const Text('Salt'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedIngredients.contains('Salt') ? Colors.grey : Colors.orange,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _addIngredient('Eggs'),
                          child: const Text('Eggs'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedIngredients.contains('Eggs') ? Colors.grey : Colors.orange,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _addIngredient('Milk'),
                          child: const Text('Milk'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedIngredients.contains('Milk') ? Colors.grey : Colors.orange,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _addIngredient('Black Pepper'),
                          child: const Text('Black Pepper'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedIngredients.contains('Black Pepper') ? Colors.grey : Colors.orange,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _addIngredient('Cardamom'),
                          child: const Text('Cardamom'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedIngredients.contains('Cardamom') ? Colors.grey : Colors.orange,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _addIngredient('Onion'),
                          child: const Text('Onion'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedIngredients.contains('Onion') ? Colors.grey : Colors.orange,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _addIngredient('Garlic'),
                          child: const Text('Garlic'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedIngredients.contains('Garlic') ? Colors.grey : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Lottie Animation at the bottom center
                  const SizedBox(height: 30), // Increased space before the animation
                  Center(
                    child: Lottie.asset('assets/animations/search.json',
                        width: 400, height: 350), // Adjust size as needed
                  ),
                ],
              ),
            ),
          );
  }
}
