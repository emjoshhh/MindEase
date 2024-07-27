import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalDetailScreen extends StatefulWidget {
  final String goalTitle;
  final String imagePath;
  final String secondaryImagePath;
  final String defaultDuration;

  GoalDetailScreen({
    required this.goalTitle,
    required this.imagePath,
    required this.secondaryImagePath,
    required this.defaultDuration,
  });

  @override
  _GoalDetailScreenState createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  String? selectedDuration;

  @override
  void initState() {
    super.initState();
    selectedDuration = widget.defaultDuration;
  }

  Widget _buildDurationButton(BuildContext context, String duration) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedDuration = duration;
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            selectedDuration == duration ? Colors.blue : Colors.grey,
          ),
        ),
        child: Text(duration),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.goalTitle,
          style: TextStyle(
            fontFamily: 'Raleway_Bold',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset(
                widget.secondaryImagePath,
                width: 400,
                height: 400,
              ),
              SizedBox(height: 20),
              Text(
                'Inhale 4s, pause 1s, exhale 4s, pause 1s',
                style: TextStyle(fontFamily: 'Raleway_SemiBold',fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Breathing for at least $selectedDuration will benefit you the most',
                style: TextStyle(fontFamily: 'Raleway',fontSize: 16),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      alignment: WrapAlignment.center,
                      children: List.generate(5, (index) {
                        List<String> durations = ['1 min', '2 min', '3 min', '4 min', '5 min'];
                        return _buildDurationButton(context, durations[index]);
                      }),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedDuration == null
                    ? null
                    : () {
                        int minutes = int.parse(selectedDuration!.split(' ')[0]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CountdownScreen(
                              duration: minutes,
                              imagePath: widget.imagePath,
                              secondaryImagePath: widget.secondaryImagePath,
                            ),
                          ),
                        );
                      },
                child: Text('Continue', style: TextStyle(fontFamily: 'Raleway'),),
              ),
              SizedBox(height: 20), // Added a bottom padding to ensure scroll
            ],
          ),
        ),
      ),
    );
  }
}

class CountdownScreen extends StatefulWidget {
  final int duration;
  final String imagePath;
  final String secondaryImagePath;

  CountdownScreen({
    required this.duration,
    required this.imagePath,
    required this.secondaryImagePath,
  });

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> with SingleTickerProviderStateMixin {
  late int _remainingSeconds;
  late AudioPlayer _audioPlayer;
  bool _isStarted = false;
  late AnimationController _controller;
  int _startButtonPressCount = 0;
  late SharedPreferences _prefs;
  int _totalDurationSpent = 0;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _remainingSeconds = widget.duration * 60;
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalDurationSpent = _prefs.getInt('totalDurationSpent') ?? 0;
      _startButtonPressCount = _prefs.getInt('startButtonPressCount') ?? 0;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_remainingSeconds > 0 && _isStarted) {
        setState(() {
          _remainingSeconds--;
        });
        _startTimer();
      } else if (_remainingSeconds == 0) {
        _showCompletionDialog();
      }
    });
  }

  void _playAudio() async {
    await _audioPlayer.play(AssetSource('audio/meditation.mp3'));
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Finish',style: TextStyle(fontFamily: 'Raleway_SemiBold'),),
          content: Text('Do you want to finish your session?',style: TextStyle(fontFamily: 'Raleway',),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(fontFamily: 'Raleway_SemiBold',),),
            ),
            ElevatedButton(
              onPressed: () {
                _updateTotalDurationSpent();
                _stopAudio();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Finish', style: TextStyle(fontFamily: 'Raleway_SemiBold')),
            ),
          ],
        );
      },
    );
  }

  void _showCompletionDialog() {
    _updateTotalDurationSpent();
    _stopAudio();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!',style: TextStyle(fontFamily: 'Raleway_Bold')),
          content: Text('You have completed the breathing exercise.',style: TextStyle(fontFamily: 'Raleway_SemiBold',)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(fontFamily: 'Raleway_SemiBold',)),
            ),
          ],
        );
      },
    );
  }

  void _updateTotalDurationSpent() async {
    if (_startTime != null) {
      final durationSpent = DateTime.now().difference(_startTime!).inSeconds;
      setState(() {
        _totalDurationSpent += durationSpent;
        _startTime = null; 
      });
      await _prefs.setInt('totalDurationSpent', _totalDurationSpent);
    }
  }

  void _updateStartButtonPressCount() async {
    setState(() {
      _startButtonPressCount++;
    });
    await _prefs.setInt('startButtonPressCount', _startButtonPressCount);
  }

  void _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isStarted = false;
    });
    _controller.stop();
  }

  void _startSession() {
    setState(() {
      _isStarted = true;
      _startTime = DateTime.now(); // Record the start time
    });
    _controller.repeat(); // Start spinning the image
    _updateStartButtonPressCount();
    _startTimer();
    _playAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.black],
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: _controller,
                    child: Image.asset(
                      'assets/images/flowers.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 20),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: Text(
                      (_remainingSeconds ~/ 60).toString().padLeft(2, '0') +
                          ':' +
                          (_remainingSeconds % 60).toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Time remaining',
                    style: TextStyle(
                      fontFamily: 'Raleway_SemiBold',
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (!_isStarted)
                    ElevatedButton(
                      onPressed: _startSession,
                      child: Text('Start',style: TextStyle(fontFamily: 'Raleway_SemiBold',)),
                    ),
                  if (_isStarted)
                    ElevatedButton(
                      onPressed: _showFinishDialog,
                      child: Text('Finish', style: TextStyle(fontFamily: 'Raleway_SemiBold',)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
