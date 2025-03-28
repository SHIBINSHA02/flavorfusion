import 'package:flutter/material.dart';

class RecipeDay extends StatelessWidget {
  final Map<String, dynamic>? currentRecipe;
  final String? selectedImage;

  const RecipeDay({
    Key? key,
    required this.currentRecipe,
    required this.selectedImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      image: selectedImage?.isNotEmpty == true
                          ? NetworkImage(selectedImage!)
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
                        currentRecipe?['title'] ?? 'Loading...',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentRecipe?['description'] ??
                            'Loading recipe details...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.timer),
                          const SizedBox(width: 8),
                          Text(currentRecipe?['cookingTime'] ?? '-- min'),
                          const SizedBox(width: 24),
                          const Icon(Icons.restaurant),
                          const SizedBox(width: 8),
                          Text(currentRecipe?['difficulty'] ?? '---'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
