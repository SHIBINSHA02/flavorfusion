import 'package:flutter/material.dart';

class PresentationPage extends StatelessWidget {
  PresentationPage({super.key});

  // Recipe data
  final String recipeName = "Simple Stir-Fry Noodles";
  final String totalTime = "20-25 minutes";
  final List<Map<String, String>> ingredients = [
    {"name": "Noodles (Spaghetti or Egg Noodles)", "quantity": "8 oz"},
    {"name": "Soy Sauce", "quantity": "3 tbsp"},
    {"name": "Sesame Oil", "quantity": "1 tbsp"},
    {"name": "Vegetable Oil", "quantity": "1 tbsp"},
    {"name": "Garlic", "quantity": "2 cloves, minced"},
    {"name": "Ginger", "quantity": "1 tsp, minced"},
    {"name": "Broccoli Florets", "quantity": "1 cup"},
    {"name": "Carrots", "quantity": "1/2 cup, sliced"},
    {"name": "Bell Pepper (any color)", "quantity": "1/2 cup, sliced"},
    {"name": "Green Onions", "quantity": "2, sliced (for garnish)"},
    {"name": "Optional Protein (Chicken, Shrimp, Tofu)", "quantity": "1 cup, cooked"},
  ];

  final List<Map<String, String>> steps = [
    {"step": "Cook Noodles", "description": "Cook noodles according to package directions. Drain and set aside."},
    {"step": "Prepare Sauce", "description": "In a small bowl, whisk together soy sauce and sesame oil."},
    {"step": "Sauté Aromatics", "description": "Heat vegetable oil in a large skillet or wok over medium-high heat. Add garlic and ginger and cook for about 30 seconds, until fragrant."},
    {"step": "Stir-Fry Vegetables", "description": "Add broccoli, carrots, and bell pepper to the skillet. Stir-fry for 5-7 minutes, until tender-crisp. Add optional protein if using."},
    {"step": "Combine and Toss", "description": "Add cooked noodles to the skillet. Pour the sauce over the noodles and vegetables. Toss to combine everything well."},
    {"step": "Garnish and Serve", "description": "Garnish with green onions and serve immediately."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.teal, // Set a solid color for the app bar
            expandedHeight: 100, // Adjust height as needed
            pinned: true,
            title: Text(recipeName, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Time: $totalTime', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 16),
                      Text('Ingredients:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ...ingredients.map((ingredient) => Text('${ingredient['name']}: ${ingredient['quantity']}')).toList(),
                      SizedBox(height: 16),
                      Text('Steps:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ...steps.map((step) => Text('${step['step']}: ${step['description']}')).toList(),
                    ],
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
