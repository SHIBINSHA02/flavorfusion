// steps_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'timer_widget.dart'; // Import the TimerWidget

class StepsPage extends StatefulWidget {
  final List<dynamic>? steps;

  StepsPage({required this.steps});

  @override
  _StepsPageState createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < (widget.steps?.length ?? 0) - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  Widget _getFlameWidget(String? flame) {
    Widget icon;
    String label;

    if (flame == null || flame.toLowerCase() == 'null') {
      icon = Icon(Icons.question_mark, color: Colors.grey);
      label = 'Unknown';
    } else if (flame.toLowerCase() == 'low') {
      icon = Icon(Icons.whatshot, color: Colors.green);
      label = 'Low';
    } else if (flame.toLowerCase() == 'medium') {
      icon = Icon(Icons.whatshot, color: Colors.orange);
      label = 'Medium';
    } else if (flame.toLowerCase() == 'high') {
      icon = Icon(Icons.whatshot, color: Colors.red);
      label = 'High';
    } else {
      icon = Icon(Icons.question_mark, color: Colors.grey);
      label = 'Unknown';
    }

    return Row(
      children: [
        icon,
        SizedBox(width: 5),
        Text('Flame: $label', style: GoogleFonts.quicksand(fontSize: 16)),
      ],
    );
  }

  Color _getGradientColor(int index, int totalSteps) {
    double opacity = index / (totalSteps - 1);
    return Color.fromRGBO(255, 165, 0, opacity);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.steps == null || widget.steps!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Recipe Steps', style: GoogleFonts.quicksand()),
        ),
        body: Center(
          child: Text('No steps available.', style: GoogleFonts.quicksand()),
        ),
      );
    }

    int totalSteps = widget.steps!.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Steps', style: GoogleFonts.quicksand()),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getGradientColor(_currentIndex, totalSteps),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: totalSteps,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final step = widget.steps![index];
                  final stepName = step['step_name']?.toString() ?? 'Step ${index + 1}';
                  final description = step['description']?.toString() ?? 'No description';

                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                stepName,
                                style: GoogleFonts.pacifico(fontSize: 28),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              Expanded( // Use Expanded to allow scrolling description
                                child: SingleChildScrollView( // Wrap description in SingleChildScrollView
                                  child: Text(
                                    description,
                                    style: GoogleFonts.quicksand(fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Time: ${step['time'] ?? 'N/A'}',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  _getFlameWidget(step['flame']),
                                ],
                              ),
                              SizedBox(height: 20),
                              TimerWidget(), // Add the TimerWidget here
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: _currentIndex > 0 ? _previousPage : null,
                  ),
                  Text('${_currentIndex + 1}/${totalSteps}',
                      style: GoogleFonts.quicksand()),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: _nextPage,
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