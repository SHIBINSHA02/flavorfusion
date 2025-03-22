import 'package:flutter/material.dart';

class FavCard extends StatefulWidget {
  final String dishName;
  final String imageUrl;
  final String description;
  final int rating;

  FavCard({
    required this.dishName,
    required this.imageUrl,
    required this.description,
    required this.rating,
  });

  @override
  _FavCardState createState() => _FavCardState();
}

class _FavCardState extends State<FavCard> {
  bool _isFavorited = false; // Track if the card is favorited

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // Main Column
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // Image and (Dishname, Rating)
                children: [
                  ClipOval(
                    child: Image.network(
                      widget.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      // Dishname and Rating
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.dishName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          // Rating Stars
                          children: List.generate(5, (index) {
                            return Icon(
                              index < widget.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  // Heart Icon
                  IconButton(
                    icon: Icon(
                      _isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorited ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorited =
                            !_isFavorited; // Toggle the favorite state
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                // Description
                child: SingleChildScrollView(
                  child: Text(
                    widget.description,
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
