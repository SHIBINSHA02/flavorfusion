import 'package:flutter/material.dart';

class PresentationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.teal, 
            expandedHeight: 300,
            pinned: true,
            floating: true,
            flexibleSpace: SafeArea(
              child: FlexibleSpaceBar(
                background: Image.network(
                  "https://www.licious.in/blog/wp-content/uploads/2022/06/chicken-hyderabadi-biryani-01.jpg",
                  fit: BoxFit.fill,
                  
                ),
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
