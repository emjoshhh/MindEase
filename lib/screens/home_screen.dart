import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_navigation_bar.dart';
import '../widgets/app_drawer.dart';
import '../utils/data_source.dart';
import 'breathing_detail_screen.dart';
import 'audio_player_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;

  HomeScreen({required this.isDarkMode, required this.onToggleDarkMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  Map<String, Map<String, List<Map<String, dynamic>>>> _plans = {};
  String? _lastGeneratedDate;
  Map<String, bool> _completedGoals = {};

  @override
  void initState() {
    super.initState();
    _initializePlans();
  }

  void _initializePlans() async {
    await _loadPlans();
    _generateDailyPlansIfNeeded();
    _loadCompletedGoals();
  }

  Future<void> _loadPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final lastGeneratedDate = prefs.getString('lastGeneratedDate');
    final plansString = prefs.getString('plans');

    if (lastGeneratedDate != null && plansString != null) {
      setState(() {
        _lastGeneratedDate = lastGeneratedDate;
        _plans =
            (jsonDecode(plansString) as Map<String, dynamic>).map((key, value) {
          return MapEntry(
              key,
              (value as Map<String, dynamic>).map((innerKey, innerValue) {
                return MapEntry(
                    innerKey,
                    (innerValue as List)
                        .map((item) => Map<String, dynamic>.from(item))
                        .toList());
              }));
        });
      });
    }
  }

  Future<void> _savePlans() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastGeneratedDate', _lastGeneratedDate!);
    await prefs.setString('plans', jsonEncode(_plans));
  }

  Future<void> _loadCompletedGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final completedGoalsString = prefs.getString('completedGoals');
    if (completedGoalsString != null) {
      setState(() {
        _completedGoals =
            Map<String, bool>.from(jsonDecode(completedGoalsString));
      });
    }
  }

  Future<void> _saveCompletedGoals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('completedGoals', jsonEncode(_completedGoals));
  }

  void _toggleGoalCompletion(String goalTitle) {
    setState(() {
      _completedGoals[goalTitle] = true;
      _saveCompletedGoals();
    });
  }

  void _generateDailyPlansIfNeeded() {
    final now = DateTime.now();
    final nowDateString = DateFormat('yyyy-MM-dd').format(now);

    if (_lastGeneratedDate == null || _lastGeneratedDate != nowDateString) {
      _generateDailyPlans();
      _lastGeneratedDate = nowDateString;
      _savePlans();
    }
  }

  void _generateDailyPlans() {
    final random = Random();
    final todayString = DateFormat('yyyy-MM-dd').format(_selectedDate);

    _plans[todayString] = {
      'Morning Plan': [],
      'Day Plan': [],
      'Evening Plan': [],
    };

    final planTypes = _plans[todayString]!;

    final morningBreathingExercise = _generateBreathingExercise(random, []);
    final morningArticle = _generateArticle(random, []);

    planTypes['Morning Plan'] = [
      morningBreathingExercise,
      morningArticle,
    ];

    final dayBreathingExercise =
        _generateBreathingExercise(random, [morningBreathingExercise]);
    final dayArticle = _generateArticle(random, [morningArticle]);

    planTypes['Day Plan'] = [
      dayBreathingExercise,
      dayArticle,
    ];

    planTypes['Evening Plan'] = [
      _generateAudio(random),
    ];

    setState(() {});
  }

  Map<String, dynamic> _generateBreathingExercise(
      Random random, List<Map<String, dynamic>> excludeList) {
    Map<String, dynamic> exercise;
    do {
      final emotion = emotions[random.nextInt(emotions.length)];
      exercise = {
        'type': 'Breathing Exercise',
        'title': 'Breathe - Reduce your ${emotion['label']}',
        'imagePath': emotion['lsImage'] ?? '',
        'secondaryImagePath': emotion['imagePath'] ?? '',
        'duration': emotion['duration'] ?? '',
      };
    } while (excludeList.any((item) => item['title'] == exercise['title']));

    return exercise;
  }

  Map<String, dynamic> _generateArticle(
      Random random, List<Map<String, dynamic>> excludeList) {
    Map<String, dynamic> article;
    do {
      final articleData = articleImage[random.nextInt(articleImage.length)];
      article = {
        'type': 'Article',
        'title': articleData['title'] ?? 'Default Title',
        'imagePath': articleData['background'] ?? '',
        'link': articleData['link'] ?? '',
        'duration': '5 min',
      };
    } while (excludeList.any((item) => item['title'] == article['title']));

    return article;
  }

  Map<String, dynamic> _generateAudio(Random random) {
    final audio = audioFiles[random.nextInt(audioFiles.length)];
    return {
      'type': 'Audio',
      'title': 'Sound to Sleep : ${audio['title'] ?? 'Default Title'}',
      'imagePath': audio['lsAudioImage'] ?? '',
      'audioPath': audio['audio'] ?? '',
      'duration': audio['duration'] ?? '',
    };
  }

  void _fetchPlansForSelectedDate(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  Widget _buildGoalCard(String goalTitle, String imagePath, String duration,
      VoidCallback onTap, bool isDarkMode, bool isCompleted) {
    return GestureDetector(
      onTap: () {
        onTap();
        _toggleGoalCompletion(goalTitle);
      },
      child: Container(
        height: 100,
        width: 500,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.80)
                  : Colors.white.withOpacity(0.80),
            ),
          ],
        ),
        child: Row(
          children: [
            isCompleted
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.circle_outlined, color: Colors.grey),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      goalTitle,
                      style: TextStyle(
                          fontFamily: 'Raleway_SemiBold', fontSize: 18),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      duration,
                      style: TextStyle(fontFamily: 'Raleway', fontSize: 14),
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

  Widget _buildPlanCard(String planType) {
    String timeOfDay;
    String imagePath;
    switch (planType) {
      case 'Morning Plan':
        timeOfDay = 'Morning';
        imagePath = 'assets/images/morning.jpg';
        break;
      case 'Day Plan':
        timeOfDay = 'Day';
        imagePath = 'assets/images/day.jpg';
        break;
      case 'Evening Plan':
        timeOfDay = 'Evening';
        imagePath = 'assets/images/night.jpg';
        break;
      default:
        timeOfDay = '';
        imagePath = '';
    }

    final todayString = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final plan = _plans[todayString]?[planType] ?? [];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$timeOfDay Plan',
                style: TextStyle(
                    fontFamily: 'Raleway_Bold',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 10),
            for (var goal in plan)
              _buildGoalCard(
                goal['title'] ?? 'Default Title',
                goal['imagePath'] ?? '',
                goal['duration'] ?? '',
                () {
                  if (goal['type'] == 'Article') {
                    _launchURL(goal['link'] ?? '');
                  } else if (goal['type'] == 'Audio') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AudioPlayerScreen(
                          audioPath: goal['audioPath'] ?? '',
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoalDetailScreen(
                          goalTitle: goal['title'] ?? 'Default Title',
                          imagePath: goal['imagePath'] ?? '',
                          secondaryImagePath: goal['secondaryImagePath'] ?? '',
                          defaultDuration: goal['duration'] ?? '',
                        ),
                      ),
                    );
                  }
                },
                widget.isDarkMode,
                _completedGoals[goal['title']] ?? false,
              ),
          ],
        ),
      ),
    );
  }

  // Method to launch URL
  void _launchURL(String url) async {
    if (url.isNotEmpty && await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  double _calculateProgress() {
    final todayString = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final totalGoals = _plans[todayString]?.values.fold<int>(
            0, (previousValue, element) => previousValue + element.length) ??
        0;
    final completedGoals =
        _completedGoals.values.where((isCompleted) => isCompleted).length;

    print("Total Goals: $totalGoals");
    print("Completed Goals: $completedGoals");

    return totalGoals > 0 ? completedGoals / totalGoals : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mental Health Plan',
          style: TextStyle(
            fontFamily: 'Raleway_Bold',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.brightness_2),
            onPressed: () => widget.onToggleDarkMode(!widget.isDarkMode),
          ),
        ],
      ),
      drawer: AppDrawer(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _calculateProgress(),
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > constraints.maxHeight) {
                  // Landscape mode
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Today's Plan - ${DateFormat.MMMMd().format(_selectedDate)}",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway_SemiBold'),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(child: _buildPlanCard('Morning Plan')),
                            Expanded(child: _buildPlanCard('Day Plan')),
                            Expanded(child: _buildPlanCard('Evening Plan')),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  // Portrait mode
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Today's Plan - ${DateFormat.MMMMd().format(_selectedDate)}",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway_SemiBold'),
                        ),
                      ),
                      _buildPlanCard('Morning Plan'),
                      _buildPlanCard('Day Plan'),
                      _buildPlanCard('Evening Plan'),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 0,
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      ),
    );
  }
}
