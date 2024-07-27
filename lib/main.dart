import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/breathing_screen.dart';
import 'screens/discover_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(
              isDarkMode: _isDarkMode,
              onToggleDarkMode: _toggleDarkMode,
            ),
        '/home': (context) => HomeScreen(
              isDarkMode: _isDarkMode,
              onToggleDarkMode: _toggleDarkMode,
            ),
        '/breathing': (context) => BreathingScreen(
              isDarkMode: _isDarkMode,
              onToggleDarkMode: _toggleDarkMode,
            ),
        '/discover': (context) => DiscoverScreen(
              isDarkMode: _isDarkMode,
              onToggleDarkMode: _toggleDarkMode,
            ),
      },
    );
  }
}
