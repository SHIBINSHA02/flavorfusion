import 'package:flutter/material.dart';
import 'FavCard.dart'; // Import the FavCard widget

class FavouritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data for the cards
    final List<Map<String, dynamic>> dishes = [
      {
        'dishName': 'Spaghetti Carbonara',
        'imageUrl':
            'https://th.bing.com/th/id/OIP.oYPGHQorMluB7LhtQUmzTgHaEK?rs=1&pid=ImgDetMain',
        'description':
            'A classic Italian pasta dish.dfgrsgrsfgsfgfshgdfhjdgjgfhrjygrhjfhyjfhbndfgjghjdfhgnbjdfgshgkfsbhgvkhdfsgjhdfghdfshgbnvdfhbngbvdkgihbdfikjhbgvnijkudfhbvijkdfnbvghiuyeiogthreifbgvrefhggiuvherwgbdjhfbvfsdbnvjefdgiufdbnvfsbd hjgvfsdiugbhnfdskjbgvdfuhgbiuerbhghjhdrfs gvjdsfbgjbdgbndsfjkbgsdbgbvhbdxgvbz',
        'rating': 4,
      },
      {
        'dishName': 'Margherita Pizza',
        'imageUrl':
            'https://th.bing.com/th/id/OIP.oYPGHQorMluB7LhtQUmzTgHaEK?rs=1&pid=ImgDetMain',
        'description': 'A simple yet delicious pizza.',
        'rating': 3,
      },
      // Add more dishes as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Dishes'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: dishes.length,
          itemBuilder: (context, index) {
            final dish = dishes[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FavCard(
                dishName: dish['dishName'],
                imageUrl: dish['imageUrl'],
                description: dish['description'],
                rating: dish['rating'],
              ),
            );
          },
          itemExtent: 250.0, // Set fixed height for each FavCard
        ),
      ),
    );
  }
}
