import 'package:flutter/material.dart';
import 'dart:math';
import 'recipe_day.dart';
import 'horizontal_recipe_list.dart';
import 'social_post_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Static variables to persist across rebuilds
  static Map<String, dynamic>? _currentRecipe;
  static DateTime? _lastUpdated;
  static String? _selectedImage;

  final List<Map<String, dynamic>> _recipes = [
    {
      'title': 'Creamy Garlic Pasta',
      'description':
          'A delicious pasta dish with creamy garlic sauce, perfect for dinner.',
      'cookingTime': '25 min',
      'difficulty': 'Easy',
      'rating': 4,
      'images': [
        '', // TODO: Add multiple image URLs for Creamy Garlic Pasta
        '',
        '',
      ],
    },
    {
      'title': 'Spicy Thai Curry',
      'description':
          'Authentic Thai curry with coconut milk and fresh vegetables.',
      'cookingTime': '35 min',
      'difficulty': 'Medium',
      'images': [
        '', // TODO: Add multiple image URLs for Spicy Thai Curry
        '',
        '',
      ],
    },
    {
      'title': 'Classic Margherita Pizza',
      'description':
          'Traditional Italian pizza with fresh basil, mozzarella, and tomatoes.',
      'cookingTime': '40 min',
      'difficulty': 'Medium',
      'images': [
        '', // TODO: Add multiple image URLs for Margherita Pizza
        '',
        '',
      ],
    },
    {
      'title': 'Grilled Salmon',
      'description': 'Fresh salmon fillet with lemon herb butter sauce.',
      'cookingTime': '20 min',
      'difficulty': 'Easy',
      'images': [
        '', // TODO: Add multiple image URLs for Grilled Salmon
        '',
        '',
      ],
    },
    {
      'title': 'Chocolate Lava Cake',
      'description': 'Decadent chocolate dessert with a gooey center.',
      'cookingTime': '15 min',
      'difficulty': 'Medium',
      'images': [
        '', // TODO: Add multiple image URLs for Chocolate Lava Cake
        '',
        '',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    checkAndLoadRecipe();
  }

  void checkAndLoadRecipe() {
    final now = DateTime.now();

    // Check if we need to load a new recipe
    if (_currentRecipe == null ||
        _lastUpdated == null ||
        _lastUpdated!.day != now.day ||
        _lastUpdated!.month != now.month ||
        _lastUpdated!.year != now.year) {
      // Select a random recipe
      final random = Random();
      _currentRecipe = _recipes[random.nextInt(_recipes.length)];

      // Select a random image from the recipe's images
      final images = _currentRecipe!['images'] as List<String>;
      _selectedImage = images[random.nextInt(images.length)];

      _lastUpdated = now;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 152, 0),
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Flavor Fusion',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Welcome, what would you like to try today?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          // Orange background with curved bottom edges
          Container(
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 152, 0),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  RecipeDay(
                    currentRecipe: _currentRecipe,
                    selectedImage: _selectedImage,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                // Popular Recipes Section
                const Text(
                  'Popular Recipes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                HorizontalRecipeList(
                  recipes: _recipes,
                ),
                const SizedBox(height: 60), // Added spacing before social posts
                const Text(
                  'Social Posts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SocialPostList(), // Integrated SocialPostList here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
