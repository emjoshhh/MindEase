import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../widgets/custom_navigation_bar.dart';
import '../widgets/app_drawer.dart';
import '../utils/data_source.dart';
import 'audio_player_screen.dart';

class DiscoverScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleDarkMode;

  DiscoverScreen({required this.isDarkMode, required this.onToggleDarkMode});

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Timer? _autoSlideTimer;
  bool _isInteracting = false;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (!_isInteracting && _pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % images.length;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
  }

  void _restartAutoSlide() {
    _stopAutoSlide();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  Widget _buildAudioCard(int index) {
    String imagePath = audioFiles[index]['image']!;
    String audioPath = audioFiles[index]['audio']!;
    String title = audioFiles[index]['title']!;
    String duration = audioFiles[index]['duration']!;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioPlayerScreen(audioPath: audioPath),
            ),
          );
        },
        child: Container(
          height: 200,
          width: 150,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    fontFamily: 'Raleway_SemiBold',
                    fontSize: 18
                  )),
              Text(duration,
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14,
                  )),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkCard(String url, String title, int index) {
    String imagePath = articleImage[index]['background']!;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Container(
          height: 140,
          width: 800,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Raleway_SemiBold',
                  fontSize: 18
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Tap to view more details',style: TextStyle(fontFamily: 'Raleway',),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover',
          style: TextStyle(fontFamily: 'Raleway_Bold'),
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
      body: GestureDetector(
        onPanDown: (_) {
          _isInteracting = true;
          _stopAutoSlide();
        },
        onPanEnd: (_) {
          _isInteracting = false;
          Future.delayed(Duration(seconds: 3), () {
            if (!_isInteracting) {
              _restartAutoSlide();
            }
          });
        },
        child: isPortrait
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mental Health Tips',
                              style: TextStyle(
                                fontFamily: 'Raleway_SemiBold',
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return Image.asset(
                                    images[index],
                                    fit: BoxFit.cover,
                                  );
                                },
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mental Health Articles',
                              style: TextStyle(
                                fontFamily: 'Raleway_SemiBold',
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: articleImage
                                  .asMap()
                                  .entries
                                  .map((entry) => _buildLinkCard(
                                      entry.value['link']!,
                                      entry.value['title']!,
                                      entry.key))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sound to Sleep',
                              style: TextStyle(
                                fontFamily: 'Raleway_SemiBold',
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: audioFiles
                                  .asMap()
                                  .entries
                                  .map((entry) => _buildAudioCard(entry.key))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      Container(
                        width: constraints.maxWidth * 0.6,
                        height: constraints.maxHeight * 1,
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Image.asset(
                                images[index],
                                fit: BoxFit.cover,
                              );
                            },
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: constraints.maxWidth * 0.4,
                                margin: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Mental Health Articles',
                                        style: TextStyle(
                                          fontFamily: 'Raleway_SemiBold',
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: articleImage
                                            .asMap()
                                            .entries
                                            .map((entry) => _buildLinkCard(
                                                entry.value['link']!,
                                                entry.value['title']!,
                                                entry.key))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: constraints.maxWidth * 0.4,
                                margin: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Sound to Sleep',
                                        style: TextStyle(
                                          fontFamily: 'Raleway_SemiBold',
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: audioFiles
                                            .asMap()
                                            .entries
                                            .map((entry) =>
                                                _buildAudioCard(entry.key))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 2,
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      ),
    );
  }
}
