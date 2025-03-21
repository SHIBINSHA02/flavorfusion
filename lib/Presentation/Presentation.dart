import 'package:flutter/material.dart';
import 'start_card.dart';
import 'recipe_details_page.dart';
import 'dart:math';

class PresentationPage extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  PresentationPage({required this.recipeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
      ),
      body: Stack(
        children: [
          // Background with smoke wave effect
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange.shade200,
                  Colors.orange.shade50,
                ],
              ),
            ),
            child: AnimatedBuilder(
              animation: Listenable.merge([]), // Animate based on time
              builder: (context, child) {
                final time = DateTime.now().millisecondsSinceEpoch / 1000.0; // Time for animation
                return CustomPaint(
                  painter: SmokeWavePainter(time: time),
                  size: Size.infinite,
                );
              },
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StartCard(
                    title: recipeData['recipe_name'] ?? 'Recipe',
                    imageUrl: recipeData['image_url'] ?? 'https://via.placeholder.com/200',
                    description: recipeData['description'] ?? 'No description available.',
                    totalTime: recipeData['total_time'] ?? 'N/A',
                    onStart: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailsPage(recipeData: recipeData),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmokeWavePainter extends CustomPainter {
  final double time;

  SmokeWavePainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x < size.width; x += 5) {
      final y = size.height / 2 + sin(x / 50 + time) * 50;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second layer for more complex smoke look
    final path2 = Path();
    path2.moveTo(0, size.height);

    for (double x = 0; x < size.width; x += 10) {
      final y = size.height / 2 + cos(x / 30 + time * 1.2) * 30;
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.close();

    paint.color = Colors.orange.withOpacity(0.2);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint every frame for animation
  }
}