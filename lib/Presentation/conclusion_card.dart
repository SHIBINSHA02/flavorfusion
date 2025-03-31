import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConclusionCard extends StatefulWidget {
  final Map<String, dynamic> recipeData;

  const ConclusionCard({required this.recipeData, super.key});

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
        backgroundColor: Colors.orange[700], // Orange AppBar
        title: Text(
          'Recipe Conclusion',
          style: GoogleFonts.quicksand(
            color: Colors.white, // White text for contrast
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // White icons
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: Colors.white, // White background for card
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.recipeData['recipe_name'] ?? 'Recipe Conclusion',
                  style: GoogleFonts.pacifico(
                    fontSize: 28,
                    color: Colors.black, // Black for title
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  widget.recipeData['conclusion'] ?? 'No conclusion available.',
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    color: Colors.black87, // Slightly softer black for body
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Rate this recipe:',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: Colors.black, // Black for label
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating.floor()
                                ? Icons.star
                                : index < _rating
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: Colors.orange[600], // Orange stars
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = (index + 1).toDouble();
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.orange[700], // Orange for favorite icon
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                ),
                Text(
                  _isFavorite ? 'Added to Favorites' : 'Add to Favorites',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.black54, // Softer black for subtle text
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700], // Orange button
                        foregroundColor: Colors.white, // White text/icon
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        // Add your post functionality here
                      },
                      child: Text(
                        'Post',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Black button
                        foregroundColor: Colors.white, // White text/icon
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        // Add your save functionality here
                      },
                      child: Text(
                        'Save',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}