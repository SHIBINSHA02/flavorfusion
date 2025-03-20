// lib/Shopping/Shopping.dart
import 'dart:convert'; // Add this import for JSON handling
import 'package:flutter/services.dart'; // Add this import for loading JSON files
import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  // Change to StatefulWidget
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<dynamic> dishes = []; // List to hold dish data

  @override
  void initState() {
    super.initState();
    loadDishes(); // Load dishes from JSON
  }

  Future<void> loadDishes() async {
    try {
      final String response =
          await rootBundle.loadString('lib/Shopping/dishes.json');
      final data = await json.decode(response);
      print("Loaded JSON: $data"); // Print the loaded data
      setState(() {
        dishes = data;
      });
    } catch (e) {
      print("Error loading dishes: $e");
    }
  }

  void deleteDish(int index) {
    setState(() {
      dishes.removeAt(index); // Remove dish from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dishes.length, // Use the length of the dishes list
        itemBuilder: (context, index) {
          final dish = dishes[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish['name'], // Use dish name from JSON
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                      height: 8.0), // Space between dish name and ingredients
                  Column(
                    children: List.generate(dish['ingredients'].length,
                        (ingredientIndex) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: dish['ingredients'][ingredientIndex]
                                          ['checked'] ??
                                      false, // Checkbox state
                                  onChanged: (bool? value) {
                                    setState(() {
                                      dish['ingredients'][ingredientIndex]
                                              ['checked'] =
                                          value; // Update checked state
                                    });
                                  },
                                ),
                                Text(
                                  '${dish['ingredients'][ingredientIndex]['name']} (x${dish['ingredients'][ingredientIndex]['quantity']})', // Display ingredient name and quantity
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete), // Delete icon
                            onPressed: () {
                              deleteIngredient(index,
                                  ingredientIndex); // Call delete function
                            },
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void deleteIngredient(int dishIndex, int ingredientIndex) {
    setState(() {
      dishes[dishIndex]['ingredients']
          .removeAt(ingredientIndex); // Remove ingredient from the list
    });
  }
}
