import 'package:flutter/material.dart';
import '../Presentation/Presentation.dart';

class RecipeDay extends StatelessWidget {
  final Map<String, dynamic>? currentRecipe;
  final String? selectedImage;

  const RecipeDay({
    super.key,
    required this.currentRecipe,
    required this.selectedImage,
  });

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
        GestureDetector(
          onTap: () {
            if (currentRecipe != null) {
              // Navigate to presentation page with the recipe data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PresentationPage(recipeData: currentRecipe!),
                ),
              );
            }
          },
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: selectedImage?.isNotEmpty == true
                          ? Image.network(
                              selectedImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/placeholder.jpg',
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              'assets/placeholder.jpg',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentRecipe?['recipe_name'] ?? 'Loading...',
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
                            Text(currentRecipe?['total_time'] ?? '-- min'),
                            const SizedBox(width: 24),
                            const Icon(Icons.restaurant),
                            const SizedBox(width: 8),
                            Text(
                              currentRecipe?['difficulty'] ?? 'Medium',
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
