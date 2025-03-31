import 'dart:ui'; // Required for BackdropFilter
import 'package:flutter/material.dart';
import 'FavCard.dart'; // Import the FavCard widget
import 'package:lottie/lottie.dart'; // Import Lottie package

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward().then((_) {
        setState(() {
          _isAnimationComplete = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
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
        'description':
            'A classic Italian pasta dish with creamy egg sauce and pancetta.',
        'rating': 4,
      },
      {
        'dishName': 'Margherita Pizza',
        'imageUrl':
            'https://th.bing.com/th/id/OIP.oYPGHQorMluB7LhtQUmzTgHaEK?rs=1&pid=ImgDetMain',
        'description':
            'A simple yet delicious pizza with fresh tomatoes and mozzarella.',
        'rating': 3,
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Main content
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
                        const Icon(
                          Icons.restaurant_menu,
                          color: Colors.white,
                          size: 47,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'FlavorFusion',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
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
                    itemExtent: 250.0,
                  ),
                ),
              ),
            ],
          ),
          // Blur effect and centered Lottie animation
          if (!_isAnimationComplete)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur intensity
              child: Container(
                color: Colors.black.withOpacity(0.2), // Optional overlay for contrast
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      'assets/animations/heart.json',
                      controller: _controller,
                      fit: BoxFit.contain,
                      onLoaded: (composition) {
                        _controller.forward(from: 0.0);
                        Future.delayed(const Duration(seconds: 2), () {
                          _controller.stop();
                          setState(() {
                            _isAnimationComplete = true;
                          });
                        });
                      },
                    ),
                  ),
                ),
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