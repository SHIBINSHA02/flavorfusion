import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  final List<String> animations = [
    'assets/animations/loading.json',
    'assets/animations/loading1.json',
    'assets/animations/loading2.json',
    'assets/animations/loading3.json',
    'assets/animations/loading4.json',
    'assets/animations/loading5.json',
    'assets/animations/loading6.json',
    'assets/animations/loading7.json',
    'assets/animations/loading8.json',
    'assets/animations/loading9.json',
    'assets/animations/loading10.json',
  ];

  int currentIndex = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playNextAnimation(Duration animationDuration) {
    Future.delayed(animationDuration, () {
      setState(() {
        currentIndex = (currentIndex + 1) % animations.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Lottie.asset(
            animations[currentIndex],
            width: 350,
            height: 350,
            controller: _controller,
            repeat: currentIndex == 0, // Repeat only the first animation
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..reset()
                ..forward();

              // Set 3 seconds for animations after the first, otherwise, use the animation duration for the first one.
              Duration playTime = (currentIndex != 0)
                  ? const Duration(seconds: 3)
                  : composition.duration;

              _playNextAnimation(playTime);
            },
          ),
        ),
      ),
    );
  }
}