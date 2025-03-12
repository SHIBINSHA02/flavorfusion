import 'package:http/http.dart' as http;
import 'dart:convert';
// For environment variables

class RecipeService {
  static Future<Map<String, dynamic>> generateRecipe(String foodName) async {
    final String? apiKey =
        "AIzaSyCYAg-vWQEJUT3bzUQzwhsBTWaLxAfvobA"; // Load API Key

    if (apiKey == null) {
      throw Exception("API Key not found. Make sure to add it in .env file.");
    }

    const String apiUrl =
        "https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent";

    // Construct the request payload
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

    final response = await http.post(
      Uri.parse("$apiUrl?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String rawResponse =
          data["candidates"][0]["content"]["parts"][0]["text"];

      // Log the raw response for debugging
      print('Raw Response: $rawResponse');

      // Remove Markdown formatting if present
      final String jsonString = rawResponse.startsWith("```json")
          ? rawResponse.substring(7, rawResponse.length - 3).trim()
          : rawResponse;

      // Attempt to decode the JSON and handle potential errors
      try {
        return json.decode(jsonString);
      } catch (e) {
        throw Exception("Failed to decode JSON: $e. Raw JSON: $jsonString");
      }
    } else {
      throw Exception("Failed to generate recipe: ${response.body}");
    }
  }

  // Function to generate the prompt
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
}
