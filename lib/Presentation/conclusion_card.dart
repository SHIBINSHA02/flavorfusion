// conclusion_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConclusionCard extends StatefulWidget {
  final Map<String, dynamic> recipeData;

  ConclusionCard({required this.recipeData});

  @override
  _ConclusionCardState createState() => _ConclusionCardState();
}

class _ConclusionCardState extends State<ConclusionCard> {
  double _rating = 0;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Conclusion', style: GoogleFonts.quicksand()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.recipeData['recipe_name'] ?? 'Recipe Conclusion',
                  style: GoogleFonts.pacifico(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  widget.recipeData['conclusion'] ?? 'No conclusion available.',
                  style: GoogleFonts.quicksand(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Rate this recipe:', style: GoogleFonts.quicksand(fontSize: 16)),
                    SizedBox(width: 10),
                    DropdownButton<double>(
                      value: _rating,
                      items: [0.0, 1.0, 2.0, 3.0, 4.0, 5.0].map((double value) {
                        return DropdownMenuItem<double>(
                          value: value,
                          child: Text(value.toString(), style: GoogleFonts.quicksand(fontSize: 16)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _rating = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                ),
                Text(_isFavorite ? 'Added to Favorites' : 'Add to Favorites', style: GoogleFonts.quicksand(fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}