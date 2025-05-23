# DishService Documentation

## Overview

The `DishService` class provides static methods for interacting with Firebase Firestore to manage dish-related data for users. It handles adding new dishes and recipe data to a user's collection.

## Class: DishService

### Static Members

* **`_firestore`**: An instance of `FirebaseFirestore` used for database operations.
* **`_auth`**: An instance of `FirebaseAuth` used for user authentication.

### Static Methods

#### `addDish(String dishName)`

* **Purpose**: Adds a new dish with the given `dishName` to the user's 'dishes' subcollection.
* **Parameters**:
    * `dishName` (String): The name of the dish to add.
* **Returns**:
    * `Future<String>`: A Future that resolves to the ID of the newly added dish document, or an empty string if an error occurs.
* **Logic**:
    1.  Retrieves the current user's ID.
    2.  Throws an exception if the user is not authenticated.
    3.  Adds a new document to the `users/{userId}/dishes` collection with the dish name and a server timestamp.
    4.  Returns the ID of the created document.
    5.  Handles potential errors during the process.
* **Example**:

    ```dart
    String dishId = await DishService.addDish('Pizza');
    if (dishId.isNotEmpty) {
      print('Dish added with ID: $dishId');
    } else {
      print('Failed to add dish.');
    }
    ```

#### `addRecipe(String dishId, Map<String, dynamic> recipeData)`

* **Purpose**: Adds recipe data to an existing dish document.
* **Parameters**:
    * `dishId` (String): The ID of the dish document.
    * `recipeData` (Map<String, dynamic>): A map containing the recipe data.
* **Returns**:
    * `Future<void>`: A Future that completes when the recipe data is added.
* **Logic**:
    1.  Retrieves the current user's ID.
    2.  Throws an exception if the user is not authenticated.
    3.  Sets the `recipe` field of the specified dish document using `SetOptions(merge: true)`.
    4.  Handles potential errors during the process.
* **Example**:

    ```dart
    Map<String, dynamic> recipe = {
      'ingredients': ['ingredient1', 'ingredient2'],
      'instructions': 'step 1, step 2',
    };
    await DishService.addRecipe('dishId', recipe);
    print('Recipe added to dish.');
    ```
 Collections:
    users (collection)
      Documents (user IDs):
        {userId} (document)
          Collections:
            dishes (subcollection)
              Documents (dish IDs):
                {dishId} (document)
                  Fields:
                    dishName (String): The name of the dish.
                    timestamp (Timestamp): The time the dish was added.
                    recipe (Map<String, dynamic>, optional): Recipe data for the dish.
                    ... (other dish-related fields)


Explanation:

users Collection:
This is the top-level collection that stores user data.
Each document within this collection represents a user, and the document ID is the user's unique ID (typically obtained from Firebase Authentication).
users/{userId}/dishes Subcollection:
Each user document contains a subcollection called dishes.
This subcollection stores the dishes created by that specific user.
Each document within the dishes subcollection represents a dish, and the document ID is a unique dish ID generated by Firestore.
users/{userId}/dishes/{dishId} Document:
Each dish document contains fields that store information about the dish.
dishName: Stores the name of the dish.
timestamp: Stores the time when the dish was added, using Firestore's Timestamp type.
recipe: Stores recipe data as a Map. This field is optional, allowing for dishes without recipes.
... (other dish-related fields): You can add more fields to store additional dish information, such as ratings, notes, ingredients, etc.
Key Points:

This structure uses subcollections to organize data hierarchically, which is a common and efficient practice in Firestore.
Using user IDs as document IDs in the users collection ensures that each user's data is stored separately.
The flexible Map data type for the recipe field allows for various recipe data structures.
This database structure is designed to work well with the DishService dart code provided previously.