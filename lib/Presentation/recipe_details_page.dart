import 'package:flutter/material.dart';
import 'ingredients_card.dart';
import 'steps_page.dart';

class RecipeDetailsPage extends StatefulWidget {
  final Map<String, dynamic> recipeData;

  const RecipeDetailsPage({super.key, required this.recipeData});

  @override
  _RecipeDetailsPageState createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < (widget.recipeData['ingredients']?.length ?? 0) - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StepsPage(
              steps: widget.recipeData['steps'] ?? [],
              recipeData: widget.recipeData),
        ),
      );
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> ingredients = widget.recipeData['ingredients'] ?? [];
    String recipeName = widget.recipeData['recipe_name'] ?? 'Recipe';

    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: ingredients.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return IngredientsCard(
                  name: ingredients[index]['name'] ?? 'Ingredient',
                  imageUrl: ingredients[index]['image_url'] ??
                      'https://via.placeholder.com/150',
                  quantity: ingredients[index]['quantity'] ?? 'N/A',
                  recipeName: recipeName, // Added recipeName parameter
                  onContinue: _nextPage,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _currentIndex > 0 ? _previousPage : null,
                ),
                Text('${_currentIndex + 1}/${ingredients.length}'),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _nextPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}