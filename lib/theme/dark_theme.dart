// lib/theme/dark_theme.dart
import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.teal,
  cardColor: Colors.blueGrey[800],
  textTheme: TextTheme(
    titleMedium: TextStyle(color: Colors.white, fontSize: 20),
    bodyMedium: TextStyle(color: Colors.white70),
    bodySmall: TextStyle(color: Colors.white60),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.dark, // Ensure this matches ThemeData.brightness
    primary: Colors.teal,
    onPrimary: Colors.white,
    secondary: Colors.teal[700]!,
    onSecondary: Colors.black,
    background: Colors.blueGrey[900]!,
    onBackground: Colors.white,
    surface: Colors.blueGrey[800]!,
    onSurface: Colors.white,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.blueGrey[800],
    selectedItemColor: Colors.teal,
    unselectedItemColor: Colors.white70,
  ),
);
