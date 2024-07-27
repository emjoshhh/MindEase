import 'package:flutter/material.dart';
import '../widgets/custom_navigation_bar.dart';
import '../widgets/app_drawer.dart';
import '../utils/data_source.dart';
import 'breathing_detail_screen.dart';

class BreathingScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;

  BreathingScreen({required this.isDarkMode, required this.onToggleDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Breathing',
          style: TextStyle(
            fontFamily: 'Raleway_Bold',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.brightness_2),
            onPressed: () => onToggleDarkMode(!isDarkMode),
          ),
        ],
      ),
      drawer: AppDrawer(
        isDarkMode: isDarkMode,
        onToggleDarkMode: onToggleDarkMode,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isPortrait = constraints.maxWidth < constraints.maxHeight;
            int crossAxisCount = isPortrait ? 2 : (emotions.length / 2).ceil();

            return Column(
              children: [
                Text(
                  'What do you want to reduce?',
                  style:
                      TextStyle(fontFamily: 'Raleway_SemiBold', fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: emotions.length,
                    itemBuilder: (context, index) {
                      return _buildOptionCard(
                        context,
                        emotions[index]['imagePath'] ??
                            'assets/images/mindease_logo.png',
                        emotions[index]['label'] ?? 'Unknown',
                        emotions[index]['duration'] ?? '0 min',
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 1,
        isDarkMode: isDarkMode,
        onToggleDarkMode: onToggleDarkMode,
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, String imagePath, String label, String duration) {
    return BreathingCard(
        imagePath: imagePath, label: label, duration: duration);
  }
}

class BreathingCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final String duration;

  BreathingCard(
      {required this.imagePath, required this.label, required this.duration});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalDetailScreen(
              goalTitle: label,
              imagePath: imagePath,
              secondaryImagePath: imagePath,
              defaultDuration: duration,
            ),
          ),
        );
      },
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.white, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8.0,
              left: 8.0,
              right: 8.0,
              child: Text(
                label,
                style: TextStyle(
                  height: 6,
                  fontSize: 20.0,
                  fontFamily: 'Raleway_SemiBold',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              bottom: 8.0,
              left: 8.0,
              right: 8.0,
              child: Text(
                duration,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
