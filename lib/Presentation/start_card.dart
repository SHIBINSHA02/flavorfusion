import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  final FlutterTts flutterTts = FlutterTts();
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _speakDishDetails();
  }

  void _speakDishDetails() async {
    await flutterTts.speak(widget.title);
    await flutterTts.speak(widget.description);
  }

  void _stopSpeaking() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.95;
    double cardHeight = MediaQuery.of(context).size.height * 0.75;

    return Center(
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          elevation: 8,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(color: Colors.orange, width: 2),
          ),
          margin: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14.0)),
                child: SizedBox(
                  height: cardHeight * 0.45,
                  width: double.infinity,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black12,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: cardWidth * 0.85),
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      // Description
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: cardWidth * 0.85),
                            child: Text(
                              widget.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ),
                      // Total Time with Flexible
                      Flexible(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: cardWidth * 0.85),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.timer, size: 20, color: Colors.orange),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Total Time: ${widget.totalTime}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2, // Allow wrapping to 2 lines if needed
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Start Button
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.orange, width: 2),
                          color: _isButtonPressed ? Colors.orange : Colors.white,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isButtonPressed = true;
                            });
                            _stopSpeaking();
                            Future.delayed(const Duration(milliseconds: 200), () {
                              widget.onStart();
                              setState(() {
                                _isButtonPressed = false;
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 28,
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Text(
                            'Start Cooking',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isButtonPressed ? Colors.white : Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ],
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