import 'package:http/http.dart' as http;
import 'dart:convert';
import 'image_service.dart';
import 'dart:async';
import 'DishService.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class RecipeService {
  static Future<Map<String, dynamic>> generateRecipe(String foodName) async {
    final String apiKey = "AIzaSyCYAg-vWQEJUT3bzUQzwhsBTWaLxAfvobA"; // Replace with actual API key
    const String apiUrl = "https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent";

    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": _getPrompt(foodName)}
          ]
        }
      ]
    };

    try {
      final response = await http
          .post(
            Uri.parse("$apiUrl?key=$apiKey"),
            headers: {"Content-Type": "application/json"},
            body: json.encode(requestBody),
          )
          .timeout(Duration(seconds: 30)); // Increased timeout

      debugPrint("Raw API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Ensure valid response structure
        if (data.containsKey("candidates") && data["candidates"].isNotEmpty) {
          final String rawResponse = data["candidates"][0]["content"]["parts"][0]["text"];

          // Clean up JSON response
          final String jsonString = _sanitizeJson(rawResponse);
          debugPrint('Processed JSON Response: $jsonString');

          try {
            final Map<String, dynamic> jsonResponse = json.decode(jsonString);
            return jsonResponse;
          } catch (e) {
            throw Exception("JSON Decoding Error: $e \nRaw JSON: $jsonString");
          }
        } else {
          throw Exception("Unexpected API Response Structure: ${response.body}");
        }
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Error during recipe generation: $e");
    }
  }

  static String _sanitizeJson(String rawResponse) {
    String jsonString = rawResponse.replaceAll(RegExp(r'```json|```'), '').trim();
    
    // Ensure it ends properly
    if (!jsonString.endsWith("}")) {
      throw Exception("Incomplete JSON response detected. Raw data: $jsonString");
    }

    return jsonString;
  }

  static String _getPrompt(String foodName) {
    return """
Generate a recipe in JSON format for the given food name.

Recipe = {
  "recipe_name": str,
  "description": str,
  "ingredients": [{"name": str, "quantity": str}],
  "steps": [{"index": int, "step_name": str, "description": str, "time": str, "flame": str}],
  "total_time": str,
  "conclusion": str
}

Food Name: "$foodName"

Return: A well-structured JSON response.
""";
  }

  static Future<Map<String, dynamic>> generateRecipeWithImages(String foodName) async {
    final recipe = await generateRecipe(foodName);
    final String serpApiKey = "c200a86a2bac5ff29ddc17453cc3fc8d45155b97e2455a330cba3a9b7b7b5591"; // Your SerpAPI key

    try {
      final recipeName = recipe['recipe_name'];
      final imageUrl = await ImageService.getSingleImageUrl(serpApiKey, recipeName);
      recipe['image_url'] = imageUrl;
      debugPrint("Recipe Image URL: $imageUrl");

      final List<dynamic> ingredients = recipe['ingredients'] as List<dynamic>; // Explicit type
      for (var ingredient in ingredients) {
        await Future.delayed(Duration(seconds: 1)); // Avoid rate limits
        final ingredientName = ingredient['name'];
        final ingredientImageUrl = await ImageService.getSingleImageUrl(serpApiKey, ingredientName);
        ingredient['image_url'] = ingredientImageUrl;
        debugPrint("Ingredient Image URL ($ingredientName): $ingredientImageUrl");
      }
      await Future.delayed(Duration(seconds: 1));

      // Store the recipe in Firestore
      String dishId = await DishService.addDish(recipe['recipe_name'], "Generated");
      if (dishId.isNotEmpty) {
        await DishService.addRecipe(dishId, recipe);
        await DishService.addDishProperties(dishId, 0.0, "Initial recipe");
      }

      return recipe;
    } catch (e) {
      debugPrint('Error adding images or saving to Firestore: $e');
      return recipe;
    }
  }
}
