// lib/Shopping/Shopping.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<dynamic> dishes = [];

  @override
  void initState() {
    super.initState();
    loadDishes();
  }

  Future<void> loadDishes() async {
    try {
      final String response =
          await rootBundle.loadString('lib/Shopping/dishes.json');
      final data = await json.decode(response);
      print("Loaded JSON: $data");
      setState(() {
        dishes = data;
      });
    } catch (e) {
      print("Error loading dishes: $e");
    }
  }

  void deleteDish(int index) {
    setState(() {
      dishes.removeAt(index);
    });
  }

  void deleteIngredient(int dishIndex, int ingredientIndex) {
    setState(() {
      dishes[dishIndex]['ingredients'].removeAt(ingredientIndex);
      if (dishes[dishIndex]['ingredients'].isEmpty) {
        dishes.removeAt(dishIndex);
      }
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
        itemCount: dishes.length,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dish['name'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          deleteDish(index);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
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
                                      false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      dish['ingredients'][ingredientIndex]
                                          ['checked'] = value;
                                    });
                                  },
                                ),
                                Text(
                                  '${dish['ingredients'][ingredientIndex]['name']} (x${dish['ingredients'][ingredientIndex]['quantity']})',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteIngredient(index, ingredientIndex);
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
}