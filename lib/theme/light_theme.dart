// lib/theme/light_theme.dart
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.teal,
  cardColor: Colors.teal[100],
  textTheme: TextTheme(
    titleMedium: TextStyle(color: Colors.black, fontSize: 20),
    bodyMedium: TextStyle(color: Colors.black87),
    bodySmall: TextStyle(color: Colors.black54),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.light, // Ensure this matches ThemeData.brightness
    primary: Colors.teal,
    onPrimary: Colors.white,
    secondary: Colors.teal[200]!,
    onSecondary: Colors.black,
    background: Colors.teal[50]!,
    onBackground: Colors.black,
    surface: Colors.teal[100]!,
    onSurface: Colors.black,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.teal[100],
    selectedItemColor: Colors.teal,
    unselectedItemColor: Colors.black54,
  ),
);
