import 'package:flutter/material.dart';

class ShoppingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea( // Ensures content starts below the status bar
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: 20, // Replace with the number of shopping items you want
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.shopping_bag,
                  size: 40,
                  color: Colors.teal,
                ),
                title: Text(
                  'Item ${index + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Description of Item ${index + 1}'),
                trailing: Text(
                  '\$${(index + 1) * 10}', // Example price calculation
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item ${index + 1} selected'),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
