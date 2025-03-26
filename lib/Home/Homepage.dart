import 'package:flavorfusion/Presentation/Presentation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'recipe_day.dart';
import 'horizontal_recipe_list.dart';
import 'social_post_list.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static Map<String, dynamic>? _currentRecipe;
  static DateTime? _lastUpdated;
  static String? _selectedImage;

  final List<Map<String, dynamic>> _recipes = [
    {
      'title': 'Creamy Garlic Pasta',
      'description':
          'A delicious pasta dish with creamy garlic sauce, perfect for dinner.',
      'filePath': 'assets/recipes/CreamyGarlicPasta.json',
      'cookingTime': '25 min',
      'difficulty': 'Easy',
      'rating': 4,
      'images': [
        'https://i.pinimg.com/originals/62/2b/ce/622bce5c6776637fdc512a50d31b03e9.png',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
    },
    {
      'title': 'Spicy Thai Curry',
      'description':
          'Authentic Thai curry with coconut milk and fresh vegetables.',
      'filePath': 'assets/recipes/SpicyThaiCurry.json',
      'cookingTime': '35 min',
      'difficulty': 'Medium',
      'images': [
        'https://th.bing.com/th/id/OIP.JPH2HTtvYtltJg27oggVTwHaKw?rs=1&pid=ImgDetMain',
        'https://th.bing.com/th/id/OIP.Bnt4Q7UFAm1NPQUM6bt2TQHaHa?rs=1&pid=ImgDetMain',
        'https://via.placeholder.com/150',
      ],
    },
    {
      'title': 'Classic Margherita Pizza',
      'description':
          'Traditional Italian pizza with fresh basil, mozzarella, and tomatoes.',
      'filePath': 'assets/recipes/ClassicMargheritaPizza.json',
      'cookingTime': '40 min',
      'difficulty': 'Medium',
      'images': [
        'https://th.bing.com/th/id/R.53e360edf6616a4e22e37cd5240c8e6a?rik=IEn7wantrDH9Mg&riu=http%3a%2f%2fkitchenswagger.com%2fwp-content%2fuploads%2f2016%2f04%2fmargherita-pizza-new3.jpg',
        'https://th.bing.com/th/id/OIP.RkNEvMDlrXuHyG473KFa-QHaLH?rs=1&pid=ImgDetMain'
      ],
    },
    {
      'title': 'Grilled Salmon',
      'description': 'Fresh salmon fillet with lemon herb butter sauce.',
      'filePath': 'assets/recipes/GrilledSalmon.json',
      'cookingTime': '20 min',
      'difficulty': 'Easy',
      'images': [
        'https://th.bing.com/th/id/OIP.p7Yk32-sJzmE5keNbDXcgwHaLH?w=203&h=372&c=7&r=0&o=5&pid=1.7',
        'https://th.bing.com/th/id/OIP.4M_S-v5FfmpLuZHy5QyqeQHaLH?rs=1&pid=ImgDetMain',
        'https://via.placeholder.com/150',
      ],
    },
    {
      'title': 'Chocolate Lava Cake',
      'description': 'Decadent chocolate dessert with a gooey center.',
      'filePath': 'assets/recipes/ChocolateLavaCake.json',
      'cookingTime': '15 min',
      'difficulty': 'Medium',
      'images': [
        'https://th.bing.com/th/id/OIP.nV8JyPGdRpJGqJnJMMUsywHaLH?w=203&h=304&c=7&r=0&o=5&pid=1.7',
        'https://th.bing.com/th/id/R.6401e7ab9445e1e9c9951b25c6e6b90d?rik=djL%2bZz67diCAlg&riu=http%3a%2f%2fwww.3yummytummies.com%2fwp-content%2fuploads%2f2016%2f01%2fBaileys-Molten-Chocolate-Lava-Cakes-for-2.jpg&ehk=sTKozbZeCXr0UVd9tsiVtHHGMsEWlOQ1lefcv6ArOEg%3d&risl=&pid=ImgRaw&r=0'
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
    if (_currentRecipe == null ||
        _lastUpdated == null ||
        _lastUpdated!.day != now.day ||
        _lastUpdated!.month != now.month ||
        _lastUpdated!.year != now.year) {
      final random = Random();
      _currentRecipe = _recipes[random.nextInt(_recipes.length)];
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 152, 0),
                borderRadius: BorderRadius.only(
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
                    onRecipeTap: (String filePath) async {
                      try {
                        Map<String, dynamic> recipeData =
                            await loadRecipeData(filePath);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PresentationPage(recipeData: recipeData),
                          ),
                        );
                      } catch (e) {
                        print('Error navigating to PresentationPage: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to load recipe data')),
                        );
                      }
                    },
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

  Future<Map<String, dynamic>> loadRecipeData(String filePath) async {
    try {
      final String response = await rootBundle.loadString(filePath);
      return json.decode(response);
    } catch (e) {
      print('Error loading recipe data: $e');
      return {
        'title': 'Error',
        'description': 'Failed to load recipe data.',
      };
    }
  }
}