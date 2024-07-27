import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;

  CustomNavigationBar({
    required this.currentIndex,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  void _onItemTapped(int index) {
    if (index != widget.currentIndex) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/breathing');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/discover');
          break;
        default:
          // Handle other tabs if necessary
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'My Plan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.self_improvement),
          label: 'Breathing',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Discover',
        ),
      ],
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      currentIndex: widget.currentIndex,
      onTap: _onItemTapped,
    );
  }
}
