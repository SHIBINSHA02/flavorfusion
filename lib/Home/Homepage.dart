import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,

      ),
      body: Column(
        children: [
          Lottie.asset('assets/animations/cooking.json',
          ),
          Center(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: TextButton(onPressed: (){
                  Navigator.pushNamed(context, 'searchpage');
                },
                    child: Text('Lets Get Started'),
                    style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                    )
                ),
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.35),
                        blurRadius: 6,
                        offset: Offset(0,6 ),
                      )
                    ]
                ),


              ),
            ),
          )
        ],


      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'loginpage');
        },
        shape: CircleBorder(),
        child: Image.asset('lib/images/google.png',
          fit: BoxFit.contain,
          height: 40,
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.teal,


    );
  }
}