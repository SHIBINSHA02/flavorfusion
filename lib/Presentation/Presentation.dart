// presentation_page.dart
import 'package:flutter/material.dart';

class PresentationPage extends StatelessWidget {
  final Map<String, dynamic> recipe;

  PresentationPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe['recipe_name'] ?? 'Recipe Details')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(recipe['description'] ?? 'No description available'),
            SizedBox(height: 16),
            Text('Ingredients:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (recipe['ingredients'] != null)
              for (var ingredient in recipe['ingredients'])
                Text('- ${ingredient['name']}: ${ingredient['quantity']}'),
            SizedBox(height: 16),
            Text('Steps:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (recipe['steps'] != null)
              for (var step in recipe['steps'])
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${step['index']}. ${step['step_name']}', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(step['description'] ?? 'No description'),
                    Text('Time: ${step['time'] ?? 'N/A'}, Flame: ${step['flame'] ?? 'N/A'}'),
                    SizedBox(height: 8),
                  ],
                ),
            SizedBox(height: 16),
            Text('Total Time:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(recipe['total_time'] ?? 'N/A'),
            SizedBox(height: 16),
            Text('Conclusion:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(recipe['conclusion'] ?? 'No conclusion'),
          ],
        ),
      ),
    );
  }
}