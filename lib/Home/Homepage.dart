import 'package:flutter/material.dart';
import 'dart:math';

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
      body: Stack(
        children: [
          // Orange background with curved bottom edges
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 3,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 152, 0),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          // Existing content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Recipe of the Day',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _selectedImage?.isNotEmpty == true
                                  ? NetworkImage(_selectedImage!)
                                  : const AssetImage('images/placeholder.jpg')
                                      as ImageProvider,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentRecipe?['title'] ?? 'Loading...',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _currentRecipe?['description'] ??
                                    'Loading recipe details...',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.timer),
                                  const SizedBox(width: 8),
                                  Text(_currentRecipe?['cookingTime'] ??
                                      '-- min'),
                                  const SizedBox(width: 24),
                                  const Icon(Icons.restaurant),
                                  const SizedBox(width: 8),
                                  Text(_currentRecipe?['difficulty'] ?? '---'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                // Horizontal Scrollable Recipe List
                SizedBox(
                  height: 200, // Fixed height for recipe rectangles
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _recipes[index];
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        margin: const EdgeInsets.only(right: 16),
                        child: Card(
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Recipe Image
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: const AssetImage(
                                        'assets/placeholder.jpg'),
                                  ),
                                ),
                              ),
                              // Recipe Details
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.timer, size: 16),
                                        const SizedBox(width: 4),
                                        Text(recipe['cookingTime']),
                                        const SizedBox(width: 16),
                                        const Icon(Icons.restaurant, size: 16),
                                        const SizedBox(width: 4),
                                        Text(recipe['difficulty']),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
