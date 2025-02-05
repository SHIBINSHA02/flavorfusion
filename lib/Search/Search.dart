import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 152, 0),
        title: const Text('Search Page', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16.0), // Uniform padding for the entire body
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items to the start
          children: [
            // Classic Title
            const Text(
              'Search for Recipes',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), // Spacing between title and TextField
            // Curved TextField Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(30), // Curved boundary for TextField
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove default border
                  labelText: 'Search',
                  labelStyle: const TextStyle(
                      color: Colors.black54), // Softer label color
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15), // Padding for TextField
                ),
              ),
            ),
            const SizedBox(height: 20), // Additional spacing
            // Placeholder for future content
            const Text(
              'Results will be displayed here.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
