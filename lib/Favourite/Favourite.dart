import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'FavCard.dart'; // Import the FavCard widget
import 'package:lottie/lottie.dart'; // Import Lottie package

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key); // Added key parameter

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Declare AnimationController
  bool _isAnimationComplete = false; // Track animation completion

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Total duration of the animation
    )..forward().then((_) {
        setState(() {
          _isAnimationComplete = true; // Mark animation as complete
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sample data for the cards
    final List<Map<String, dynamic>> dishes = [
      {
        'dishName': 'Spaghetti Carbonara',
        'imageUrl':
            'https://th.bing.com/th/id/OIP.oYPGHQorMluB7LhtQUmzTgHaEK?rs=1&pid=ImgDetMain',
        'description': 'A classic chocolate shake, perfect for a quick and delicious treat. This recipe is easily customizable to your preference - add more chocolate for a richer flavor, or more milk for a thinner consistency.',
        'rating': 4,
      },
      {
        'dishName': 'Margherita Pizza',
        'imageUrl':
            'https://th.bing.com/th/id/OIP.oYPGHQorMluB7LhtQUmzTgHaEK?rs=1&pid=ImgDetMain',
        'description': 'A classic chocolate shake, perfect for a quick and delicious treat. This recipe is easily customizable to your preference - add more chocolate for a richer flavor, or more milk for a thinner consistency.',
        'rating': 3,
      },
      // Add more dishes as needed
    ];

    return Scaffold( // Orange background
      body: Stack(
        // Use Stack to overlay the animation
        children: [
          Column(
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 200,
                  color: Colors.orange,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          color: Colors.white,
                          size: 47, // Increased icon size
                        ),
                        SizedBox(width: 12), // Increased spacing
                        Text(
                          'FlavorFusion',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 29, // Increased font size
                            fontWeight:
                                FontWeight.bold, // Added bold font weight
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    itemCount: dishes.length,
                    itemBuilder: (context, index) {
                      final dish = dishes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: FavCard(
                          dishName: dish['dishName'],
                          imageUrl: dish['imageUrl'],
                          description: dish['description'],
                          rating: dish['rating'],
                        ),
                      );
                    },
                    itemExtent: 250.0, // Set fixed height for each FavCard
                  ),
                ),
              ),
            ],
          ),
          // Overlay the Lottie animation
          if (!_isAnimationComplete) // Show animation only if not complete
            Positioned.fill(
              child: Lottie.asset(
                'assets/animations/heart.json',
                fit: BoxFit.cover, // Make it cover the content
                controller: _controller, // Use the AnimationController
                onLoaded: (composition) {
                  // Play only a portion of the animation
                  _controller.forward(from: 0.0); // Start from the beginning
                  Future.delayed(Duration(seconds: 2), () {
                    _controller.stop(); // Stop the animation after 2 seconds
                    setState(() {
                      _isAnimationComplete = true; // Mark animation as complete
                    });
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 3.75 * 3, size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
