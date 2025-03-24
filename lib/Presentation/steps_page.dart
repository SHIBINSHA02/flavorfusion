import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'timer_widget.dart'; // Import the TimerWidget
import 'conclusion_card.dart'; // Import the ConclusionCard

class StepsPage extends StatefulWidget {
  final List<dynamic>? steps;
  final dynamic recipeData;

  StepsPage({required this.steps, required this.recipeData});

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
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConclusionCard(recipeData: widget.recipeData),
        ),
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

  Widget? _getFlameWidget(String? flame) {
    if (flame == null ||
        flame.toLowerCase() == 'null' ||
        flame.toLowerCase() == 'unknown') {
      return null;
    }

    Widget icon;
    String label;

    if (flame.toLowerCase() == 'low') {
      icon = Icon(Icons.whatshot, color: Colors.orange);
      label = 'Low';
    } else if (flame.toLowerCase() == 'medium') {
      icon = Icon(Icons.whatshot, color: Colors.orangeAccent);
      label = 'Medium';
    } else if (flame.toLowerCase() == 'high') {
      icon = Icon(Icons.whatshot, color: Colors.deepOrange);
      label = 'High';
    } else {
      return null;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(width: 5),
        Flexible(
          child: Text(
            'Flame: $label',
            style: GoogleFonts.quicksand(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Color _getGradientColor(int index, int totalSteps) {
    double opacity = index / (totalSteps - 1);
    return Color.fromRGBO(255, 165, 0, opacity).withOpacity(0.8);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.steps == null || widget.steps!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Recipe Steps', style: GoogleFonts.quicksand(color: Colors.white)),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Text(
            'No steps available.',
            style: GoogleFonts.quicksand(color: Colors.black, fontSize: 18),
          ),
        ),
        backgroundColor: Colors.white,
      );
    }

    int totalSteps = widget.steps!.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipe Steps',
          style: GoogleFonts.quicksand(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getGradientColor(_currentIndex, totalSteps),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                  final stepName =
                      step['step_name']?.toString() ?? 'Step ${index + 1}';
                  final description =
                      step['description']?.toString() ?? 'No description';
                  final flameWidget = _getFlameWidget(step['flame']);

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Step Name at the top
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  stepName,
                                  style: GoogleFonts.pacifico(
                                    fontSize: 28,
                                    color: Colors.orange,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // Description centered both horizontally and vertically
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      description,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 18,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              // Time, Flame, and Timer at the bottom
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Time: ${step['time'] ?? 'N/A'}',
                                            style: GoogleFonts.quicksand(
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                        if (flameWidget != null) ...[
                                          SizedBox(width: 20),
                                          flameWidget,
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    TimerWidget(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.orange),
                    onPressed: _currentIndex > 0 ? _previousPage : null,
                  ),
                  Text(
                    '${_currentIndex + 1}/$totalSteps',
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward, color: Colors.orange),
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