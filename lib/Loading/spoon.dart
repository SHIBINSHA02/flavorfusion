import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                color: Colors.orange,
              ),
            ),
            Center(
              child: Lottie.asset(
                'assets/animations/loading.json', // Path to your Lottie file
                width: 350,
                height: 350,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
