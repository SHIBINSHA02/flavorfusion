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

  Future<void> _getUserIdAndLoadDishes() async {
    setState(() {
      _isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      try {
        dishes = await retrieveDishes(_userId!);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error loading dishes: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('User not signed in');
      setState(() {
        _isLoading = false;
      });
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
      List<Map<String, dynamic>> dishes = [];

      for (var doc in querySnapshot.docs) {
        dishes.add(doc.data());
      }

      return dishes;
    } catch (e) {
      print("Error retrieving dishes: $e");
      return [];
    }
  }

  void deleteDish(int index) {
    setState(() {
      if (_userId != null) {
        final dishName = dishes[index]['name'];
        print("Deleting dish: users/$_userId/shopping/$dishName");
        FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .collection('shopping')
            .doc(dishName)
            .delete()
            .then((_) {
          dishes.removeAt(index);
        }).catchError((error) {
          print("Error deleting dish: $error");
        });
      } else {
        print('User not signed in, cannot delete.');
      }
    });
  }

  void deleteIngredient(int dishIndex, int ingredientIndex) {
    setState(() {
      if (_userId != null) {
        final dishName = dishes[dishIndex]['name'];
        print("Updating Ingredients: users/$_userId/shopping/$dishName");
        dishes[dishIndex]['ingredients'].removeAt(ingredientIndex);
        if (dishes[dishIndex]['ingredients'].isEmpty) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(_userId)
              .collection('shopping')
              .doc(dishName)
              .delete()
              .then((_) {
            dishes.removeAt(dishIndex);
          }).catchError((error) {
            print("Error deleting dish: $error");
          });
        } else {
          FirebaseFirestore.instance
              .collection('users')
              .doc(_userId)
              .collection('shopping')
              .doc(dishName)
              .update({'ingredients': dishes[dishIndex]['ingredients']})
              .catchError((error) {
            print("Error updating ingredients: $error");
          });
        }
      } else {
        print('User not signed in, cannot delete.');
      }
    });
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
                      Text(
                        dish['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          deleteDish(index);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
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
                                      if (_userId != null) {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(_userId)
                                            .collection('shopping')
                                            .doc(dish['name'])
                                            .update({
                                          'ingredients': dishes[index]
                                              ['ingredients']
                                        }).catchError((error) {
                                          print("Error updating checkbox: $error");
                                        });
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  '${dish['ingredients'][ingredientIndex]['name']} (x${dish['ingredients'][ingredientIndex]['quantity']})',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
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