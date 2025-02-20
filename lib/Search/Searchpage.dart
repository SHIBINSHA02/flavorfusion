import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';





class SearchAPIExample extends StatefulWidget {
  const SearchAPIExample({super.key});

  @override
  _SearchAPIExampleState createState() => _SearchAPIExampleState();
}

class _SearchAPIExampleState extends State<SearchAPIExample> {
  final TextEditingController _controller = TextEditingController();
  List<String> suggestions = [];
  Timer? _debounce;  // To prevent excessive API calls

  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() => suggestions = []);
      return;
    }

    const String apiKey = "94ded60602fb440f9592947a0cdd9ea2";  // Replace with your Spoonacular API key
    final String url = "https://api.spoonacular.com/recipes/autocomplete?query=$query&number=10&apiKey=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        suggestions = data.map((item) => item["title"].toString()).toList();
      });
    } else {
      setState(() => suggestions = []);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () {
      fetchSuggestions(query);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("API Search Suggestions")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Search Recipes",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged, // Call API as user types
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestions[index]),
                    onTap: () {
                      _controller.text = suggestions[index];
                      FocusScope.of(context).unfocus(); // Hide keyboard
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}