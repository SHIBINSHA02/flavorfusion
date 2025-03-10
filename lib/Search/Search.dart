import 'package:flavorfusion/Presentation/Presentation.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  // Define the TextEditingController
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                      hintText: 'Enter search term',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    print(
                        'Search query: ${searchController.text}'); // Print query in terminal
                    // Navigate to PresentationPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PresentationPage()), // Redirect to PresentationPage
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
