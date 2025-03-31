import 'package:flutter/material.dart';
import 'dart:math';
import 'recipe_day.dart';
import 'horizontal_recipe_list.dart';
import 'social_post_list.dart';
import '../Search/recipe_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool _isLoading = true; // Add loading state

  final List<Map<String, dynamic>> _recipes = [
    {
      'title': 'Creamy Garlic Pasta',
      'description':
          'A delicious pasta dish with creamy garlic sauce, perfect for dinner.',
      'cookingTime': '25 min',
      'difficulty': 'Easy',
      'rating': 4,
      'images': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
    },
    {
      'title': 'Spicy Thai Curry',
      'description':
          'Authentic Thai curry with coconut milk and fresh vegetables.',
      'cookingTime': '35 min',
      'difficulty': 'Medium',
      'rating': 4,
      'images': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
    },
    {
      'title': 'Classic Margherita Pizza',
      'description':
          'Traditional Italian pizza with fresh basil, mozzarella, and tomatoes.',
      'cookingTime': '40 min',
      'difficulty': 'Medium',
      'rating': 5,
      'images': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
    },
    {
      'title': 'Grilled Salmon',
      'description': 'Fresh salmon fillet with lemon herb butter sauce.',
      'cookingTime': '20 min',
      'difficulty': 'Easy',
      'rating': 4,
      'images': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
    },
    {
      'title': 'Chocolate Lava Cake',
      'description': 'Decadent chocolate dessert with a gooey center.',
      'cookingTime': '15 min',
      'difficulty': 'Medium',
      'rating': 5,
      'images': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Show UI immediately with a random recipe
    final random = Random();
    final selectedRecipe = _recipes[random.nextInt(_recipes.length)];
    _currentRecipe = {
      'recipe_name': selectedRecipe['title'],
      'description': selectedRecipe['description'],
      'total_time': selectedRecipe['cookingTime'],
      'difficulty': selectedRecipe['difficulty'],
      'image_url': selectedRecipe['images'][0],
    };
    _selectedImage = selectedRecipe['images'][0];
    _isLoading = false;

    // Load full recipe in background
    Future.microtask(() => checkAndLoadRecipe());
  }

  Future<void> checkAndLoadRecipe() async {
    final now = DateTime.now();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Try to get existing recipe from Firestore first
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('recipe_of_the_day')
          .doc('current')
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          final lastUpdated = (data['last_updated'] as Timestamp).toDate();
          // Only use cached recipe if it's from today
          if (lastUpdated.day == now.day && 
              lastUpdated.month == now.month && 
              lastUpdated.year == now.year) {
            if (mounted) {
              setState(() {
                _currentRecipe = data['recipe'];
                _selectedImage = data['recipe']['image_url'];
                _lastUpdated = lastUpdated;
              });
            }
            return;
          }
        }
      }
    } catch (e) {
      print('Error fetching cached recipe: $e');
    }

    // If no valid cached recipe, generate a new one
    try {
      // Select a random recipe from our list
      final random = Random();
      final selectedRecipe = _recipes[random.nextInt(_recipes.length)];

      // Generate the recipe with real images using the same service as popular recipes
      final generatedRecipe = await RecipeService.generateRecipeWithImages(
        selectedRecipe['title']!,
        searchType: 'Search Recipe',
      );

      // Add the difficulty from the selected recipe
      generatedRecipe['difficulty'] = selectedRecipe['difficulty'];

      // Store in Firestore under recipe_of_the_day collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('recipe_of_the_day')
          .doc('current')
          .set({
        'recipe': generatedRecipe,
        'last_updated': now,
      });

      if (mounted) {
        setState(() {
          _currentRecipe = generatedRecipe;
          _selectedImage = generatedRecipe['image_url'];
          _lastUpdated = now;
        });
      }
    } catch (e) {
      print('Error generating recipe: $e');
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Orange background with curved bottom edges
                  Container(
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
                        const SizedBox(height: 60),
                        const Text(
                          'Social Posts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SocialPostList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}