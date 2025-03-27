import 'package:flutter/material.dart';

class HorizontalRecipeList extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;

  const HorizontalRecipeList({
    Key? key,
    required this.recipes,
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
          return Container(
            width: MediaQuery.of(context).size.width * 0.7,
            margin: const EdgeInsets.only(right: 16),
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
                          recipe['rating'].toString(), // Display the rating
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
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
          );
        },
      ),
    );
  }
}
