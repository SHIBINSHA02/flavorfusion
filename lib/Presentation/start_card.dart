import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';

class StartCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String description;
  final String totalTime;
  final VoidCallback onStart;

  const StartCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.totalTime,
    required this.onStart,
  }) : super(key: key);

  @override
  _StartCardState createState() => _StartCardState();
}

class _StartCardState extends State<StartCard> {
  late TextToSpeech tts;

  @override
  void initState() {
    super.initState();
    tts = TextToSpeech();
    speak();
  }

  void speak() {
    String text = "${widget.title}. ${widget.description}";
    tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                widget.imageUrl,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: speak,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 20, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Total Time: ${widget.totalTime}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onStart();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      ),
                      child: Text(
                        'Start Cooking',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
