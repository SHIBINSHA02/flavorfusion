import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<Map<String, dynamic>> dishes = [];
  bool _isLoading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _getUserIdAndLoadDishes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getUserIdAndLoadDishes() async {
    setState(() {
      _isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      try {
        final loadedDishes = await retrieveDishes(_userId!);
        if (mounted) { // Check if widget is still mounted
          setState(() {
            dishes = loadedDishes;
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error loading dishes: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      print('User not signed in');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> retrieveDishes(String userId) async {
    if (userId.isEmpty) {
      print("No user is currently signed in.");
      return [];
    }

    try {
      final firestore = FirebaseFirestore.instance;
      final collectionRef =
          firestore.collection('users').doc(userId).collection('shopping');

      final querySnapshot = await collectionRef.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['name'] = doc.id; // Use document ID as dish name
        return data;
      }).toList();
    } catch (e) {
      print("Error retrieving dishes: $e");
      return [];
    }
  }

  Future<void> deleteDish(int index) async {
    if (_userId == null) {
      print('User not signed in, cannot delete.');
      return;
    }

    final dishName = dishes[index]['name'];
    print("Deleting dish: users/$_userId/shopping/$dishName");

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('shopping')
          .doc(dishName)
          .delete();

      if (mounted) {
        setState(() {
          dishes.removeAt(index);
        });
      }
    } catch (error) {
      print("Error deleting dish: $error");
    }
  }

  Future<void> deleteIngredient(int dishIndex, int ingredientIndex) async {
    if (_userId == null) {
      print('User not signed in, cannot delete.');
      return;
    }

    final dishName = dishes[dishIndex]['name'];
    print("Updating Ingredients: users/$_userId/shopping/$dishName");

    try {
      final updatedIngredients = List.from(dishes[dishIndex]['ingredients']);
      updatedIngredients.removeAt(ingredientIndex);

      if (updatedIngredients.isEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .collection('shopping')
            .doc(dishName)
            .delete();
        if (mounted) {
          setState(() {
            dishes.removeAt(dishIndex);
          });
        }
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .collection('shopping')
            .doc(dishName)
            .update({'ingredients': updatedIngredients});
        if (mounted) {
          setState(() {
            dishes[dishIndex]['ingredients'] = updatedIngredients;
          });
        }
      }
    } catch (error) {
      print("Error updating ingredients: $error");
    }
  }

  Future<void> updateCheckbox(int dishIndex, int ingredientIndex, bool? value) async {
    if (_userId == null) {
      print('User not signed in, cannot update.');
      return;
    }

    try {
      final updatedIngredients = List.from(dishes[dishIndex]['ingredients']);
      updatedIngredients[ingredientIndex]['checked'] = value;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('shopping')
          .doc(dishes[dishIndex]['name'])
          .update({'ingredients': updatedIngredients});

      if (mounted) {
        setState(() {
          dishes[dishIndex]['ingredients'] = updatedIngredients;
        });
      }
    } catch (error) {
      print("Error updating checkbox: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping'),
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
                      Flexible(
                        child: Text(
                          dish['name'] ?? 'Unnamed Dish',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () => deleteDish(index),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Column(
                    children: List.generate(dish['ingredients']?.length ?? 0,
                        (ingredientIndex) {
                      final ingredient = dish['ingredients'][ingredientIndex];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: ingredient['checked'] ?? false,
                                  onChanged: (bool? value) {
                                    updateCheckbox(index, ingredientIndex, value);
                                  },
                                ),
                                Flexible(
                                  child: Text(
                                    '${ingredient['name'] ?? 'Unknown'} (x${ingredient['quantity'] ?? 'N/A'})',
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteIngredient(index, ingredientIndex),
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