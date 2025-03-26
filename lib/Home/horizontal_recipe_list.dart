import 'package:flutter/material.dart';

class HorizontalRecipeList extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;
  final Function(String) onRecipeTap;

  const HorizontalRecipeList({
    Key? key,
    required this.recipes,
    required this.onRecipeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Fixed height for recipe rectangles
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return GestureDetector(
            onTap: () {
              onRecipeTap(recipe['filePath']);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7 > 300
                  ? 300
                  : MediaQuery.of(context).size.width * 0.7, // Max width of 300
              margin: const EdgeInsets.only(right: 16),
              child: Card(
                elevation: 4,
                child: Stack(
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
                              image: (recipe['images'] != null &&
                                      recipe['images'].isNotEmpty)
                                  ? NetworkImage(recipe['images'][0])
                                  : const NetworkImage(
                                      'https://via.placeholder.com/150'), // Default network placeholder
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
                                recipe['title'] ?? 'Unnamed Recipe',
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
                                      recipe['cookingTime'] ?? 'N/A',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.restaurant, size: 16),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      recipe['difficulty'] ?? 'N/A',
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
                            recipe['rating'] != null
                                ? recipe['rating'].toString()
                                : 'N/A', // Handle null rating
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