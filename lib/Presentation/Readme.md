# RecipeDetailsPage Documentation

## Overview
`RecipeDetailsPage` is a Flutter stateful widget that displays a recipe's details, including a paginated list of ingredients and a navigation option to view the preparation steps.

## Class: `RecipeDetailsPage`

### Constructor
```dart
RecipeDetailsPage({required this.recipeData});
```
- **Description:**
  - Initializes a `RecipeDetailsPage` instance with the provided recipe data.
- **Parameters:**
  - `recipeData`: A `Map<String, dynamic>` containing details about the recipe, including `ingredients` (a list of ingredient details) and `steps` (a list of recipe steps).
- **Returns:**
  - A `RecipeDetailsPage` widget.

---

## Class: `_RecipeDetailsPageState`
Manages the state of the `RecipeDetailsPage`, handling ingredient navigation and transition to the steps page.

### `initState()`
```dart
@override
void initState();
```
- **Description:**
  - Initializes `_pageController` with an initial page index, allowing navigation between ingredients.
  - Called automatically when the widget is inserted into the tree.
- **Parameters:**
  - None
- **Returns:**
  - Void

---

### `dispose()`
```dart
@override
void dispose();
```
- **Description:**
  - Disposes of `_pageController` to free up memory and prevent memory leaks when the widget is removed.
- **Parameters:**
  - None
- **Returns:**
  - Void

---

### `_nextPage()`
```dart
void _nextPage();
```
- **Description:**
  - Moves to the next ingredient in the list if available.
  - If the last ingredient has been displayed, it navigates to the `StepsPage` to show the recipe steps.
- **Parameters:**
  - None
- **Returns:**
  - Void
- **Navigation:**
  - Calls `Navigator.push` to open `StepsPage` when the last ingredient is reached.

---

### `_previousPage()`
```dart
void _previousPage();
```
- **Description:**
  - Moves to the previous ingredient page if not already at the first page.
- **Parameters:**
  - None
- **Returns:**
  - Void

---

### `build(BuildContext context)`
```dart
@override
Widget build(BuildContext context);
```
- **Description:**
  - Builds the UI for the recipe details page.
  - Displays an `AppBar` with the recipe name.
  - Uses a `PageView` widget to allow swiping through ingredients.
  - Displays navigation controls (previous/next buttons) and the current ingredient index.
  - When the last ingredient is reached, the next button navigates to `StepsPage`.
- **Parameters:**
  - `context`: The `BuildContext` for the widget tree.
- **Returns:**
  - A `Scaffold` widget containing the UI elements.

---

## UI Components
- **AppBar:** Displays the recipe name.
- **PageView:** Cycles through ingredient cards using `_pageController`.
- **Navigation Controls:**
  - `IconButton` for previous and next ingredient navigation.
  - Displays the current ingredient index out of total ingredients.
- **Steps Navigation:**
  - When the last ingredient is reached, clicking forward navigates to `StepsPage`.

---

## Dependencies
- `ingredients_card.dart`: Displays individual ingredient details.
- `steps_page.dart`: Displays the recipe preparation steps.

---

## Example Usage
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => RecipeDetailsPage(recipeData: recipeData),
  ),
);
```

---

## Notes
- Ensure `recipeData` contains a valid `ingredients` list to avoid runtime errors.
- Handles cases where `ingredients` or `steps` are missing by using default values.

