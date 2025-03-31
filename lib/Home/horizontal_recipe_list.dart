import 'package:flutter/material.dart';
import '../Presentation/Presentation.dart';
import '../Fetch/Recipe&rate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HorizontalRecipeList extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;

  const HorizontalRecipeList({
    super.key,
    required this.recipes,
  });

  Future<Map<String, dynamic>?> _getRecipeFromFirestore(String recipeName) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return null;

    // Get all dishes for the user
    final dishesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('dishes')
        .get();

    // Find the dish with matching recipe name
    for (var doc in dishesSnapshot.docs) {
      final data = doc.data();
      if (data['recipe']?['recipe_name'] == recipeName) {
        return data['recipe'];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Fixed height for recipe rectangles
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Container(
            width: MediaQuery.of(context).size.width * 0.7,
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () async {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                // Try to get the complete recipe from Firestore
                final completeRecipe = await _getRecipeFromFirestore(recipe['title']);
                
                // Hide loading indicator
                Navigator.pop(context);

                if (completeRecipe != null) {
                  // Navigate with complete recipe data
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PresentationPage(
                          recipeData: completeRecipe,
                        ),
                      ),
                    );
                  }
                } else {
                  // If no complete recipe found, show preview data
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PresentationPage(
                          recipeData: {
                            'recipe_name': recipe['title'],
                            'description': recipe['description'],
                            'total_time': recipe['cookingTime'],
                            'image_url': recipe['images'][0],
                            'ingredients': [], // Empty list as these are preview recipes
                            'steps': [], // Empty list as these are preview recipes
                          },
                        ),
                      ),
                    );
                  }
                }
              },
              child: Card(
                elevation: 4,
                child: Stack(
                  // Use Stack to position elements
                  children: [
                    Column(
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
                              image: const AssetImage('assets/placeholder.jpg'),
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
                                  Flexible(
                                    child: Text(
                                      recipe['cookingTime'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.restaurant, size: 16),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      recipe['difficulty'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Rating in the bottom right corner
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Row(
                        children: [
                          Text(
                            recipe['rating']?.toString() ?? '0',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.star,
                            size: 22,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
