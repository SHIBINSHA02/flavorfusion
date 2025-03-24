import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Stopwatch _stopwatch;
  Duration _elapsedTime = Duration.zero;
  bool _isRunning = false;
  Duration _setDuration = Duration.zero;
  Duration _remainingTime = Duration.zero;
  late AudioPlayer _audioPlayer;
  bool _alarmPlaying = false; // Add this line

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  void _startTimer() {
    if (!_isRunning) {
      _stopwatch.start();
      setState(() {
        _isRunning = true;
      });
      _updateTimer();
    }
  }

  void _pauseTimer() {
    if (_isRunning) {
      _stopwatch.stop();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _resetTimer() {
    _stopwatch.reset();
    setState(() {
      _elapsedTime = Duration.zero;
      _remainingTime = _setDuration;
      _isRunning = false;
      _alarmPlaying = false; //reset alarm state
    });

    _audioPlayer.stop(); //stop the audio if playing
  }

  void _updateTimer() {
    if (_isRunning) {
      setState(() {
        _elapsedTime = _stopwatch.elapsed;
        if (_setDuration != Duration.zero) {
          _remainingTime = _setDuration - _elapsedTime;
          if (_remainingTime.isNegative) {
            _remainingTime = Duration.zero;
            _pauseTimer();
            _showTimerEndedDialog();
          }
        }
      });
      Future.delayed(Duration(milliseconds: 10), _updateTimer);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  Future<void> _showSetTimerDialog(BuildContext context) async {
    int minutes = 0;
    int seconds = 0;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Timer'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNumberPicker(
                        value: minutes,
                        onChanged: (value) => setState(() => minutes = value),
                        label: 'Minutes',
                      ),
                      _buildNumberPicker(
                        value: seconds,
                        onChanged: (value) => setState(() => seconds = value),
                        label: 'Seconds',
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Set'),
              onPressed: () {
                setState(() {
                  _setDuration = Duration(minutes: minutes, seconds: seconds);
                  _remainingTime = _setDuration;
                  _resetTimer();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNumberPicker({
    required int value,
    required ValueChanged<int> onChanged,
    required String label,
  }) {
    return Column(
      children: [
        Text(label),
        DropdownButton<int>(
          value: value,
          onChanged: (int? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          items: List.generate(60,
              (index) => DropdownMenuItem(value: index, child: Text('$index'))),
        ),
      ],
    );
  }

  void _showTimerEndedDialog() async {
    _alarmPlaying = true; // Set alarm playing flag
    _playAlarmRepeatedly();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Timer Ended!'),
          content: Text('Time is up!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                _alarmPlaying = false; // Stop alarm playing
                _audioPlayer.stop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _playAlarmRepeatedly() async {
    while (_alarmPlaying) {
      try {
        await _audioPlayer.setAudioSource(
          AudioSource.asset('assets/Presentation/sound.mp3'),
        );
        await _audioPlayer.play();
        await Future.delayed(Duration(seconds: 3)); // 3-second delay
      } catch (e) {
        print("Error playing alarm: $e");
        _alarmPlaying = false; // Stop if error occurs
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.orange, width: 2.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _setDuration == Duration.zero
                ? _formatDuration(_elapsedTime)
                : _formatDuration(_remainingTime),
            style: GoogleFonts.quicksand(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(
                icon: _isRunning ? Icons.pause : Icons.play_arrow,
                onPressed: _isRunning ? _pauseTimer : _startTimer,
                color: const Color.fromARGB(255, 232, 152, 23),
              ),
              SizedBox(width: 16),
              _buildIconButton(
                icon: Icons.replay,
                onPressed: _resetTimer,
                color: const Color.fromARGB(255, 232, 152, 23),
              ),
              SizedBox(width: 16),
              _buildIconButton(
                icon: Icons.timer,
                onPressed: () => _showSetTimerDialog(context),
                color: const Color.fromARGB(255, 232, 152, 23),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(12),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
  }
}
