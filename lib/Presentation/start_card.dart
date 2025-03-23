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

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.9;
    double cardHeight = MediaQuery.of(context).size.height * 0.7;

    return Center(
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16.0)),
                child: SizedBox(
                  height: cardHeight * 0.4,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                            child: Icon(Icons.broken_image,
                                size: 50, color: Colors.grey)),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Center(
                          child: Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.timer, size: 20, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            'Total Time: ${widget.totalTime}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: _isButtonPressed
                                  ? const Color.fromARGB(0, 255, 255, 255)
                                  : Colors.orange,
                            ),
                            color: _isButtonPressed
                                ? Colors.orange
                                : const Color.fromARGB(0, 255, 255, 255),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isButtonPressed = true;
                              });
                              Future.delayed(const Duration(milliseconds: 200),
                                  () {
                                widget.onStart();
                                setState(() {
                                  _isButtonPressed = false;
                                });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 32),
                              backgroundColor:
                                  const Color.fromARGB(0, 255, 255, 255),
                              shadowColor:
                                  const Color.fromARGB(0, 255, 255, 255),
                            ),
                            child: Text(
                              'Start Cooking',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _isButtonPressed
                                    ? Colors.white
                                    : const Color.fromARGB(255, 251, 159, 1),
                              ),
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
