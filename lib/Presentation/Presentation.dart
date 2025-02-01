import 'package:flutter/material.dart';

class PresentationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.teal, 
            expandedHeight: screenHeight/3,
            pinned: true,
            title: Text("Chicken Biriyani",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
            [SizedBox(height: 200),
              Container(height: 400, color: Colors.red),
              Container(height: 400, color: Colors.green),
              Container(height: 400, color: Colors.blue),
        ],
      ),
    ),
        ],
      ),
    );
  }
}
