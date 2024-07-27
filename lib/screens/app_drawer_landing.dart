import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Account',
            style: TextStyle(fontFamily: 'Raleway_Bold', color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dark_2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              height: 600,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/images/app_drawer_background.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4), BlendMode.darken),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.black,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/for_circle_avatar.png',
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Josh Tumbaga',
                    style: TextStyle(
                      fontFamily: 'Raleway_SemiBold',
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'tumbebi@gmail.com',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 25,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Support',
            style: TextStyle(fontFamily: 'Raleway_Bold', color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dark_2.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.darken),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildHotlineCard(
                  context,
                  'NEW NATIONAL CENTER FOR MENTAL HEALTH (NCMH) CRISIS HOTLINES',
                  '09178998727 (USAP)',
                ),
                _buildHotlineCard(
                  context,
                  'NATASHA GOULBOURN FOUNDATION (NGF) / HOPELINE PHILIPPINES',
                  '0917-558-4673 (Globe)',
                  '0918-873-4673 (Smart)',
                ),
                _buildHotlineCard(
                  context,
                  'RAPHA',
                  '0961-7182655',
                  'cptcsa.helpline@gmail.com',
                ),
                _buildHotlineCard(
                  context,
                  'MANILA LIFELINE CENTRE (MLC)',
                  '0917-854-9191',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotlineCard(BuildContext context, String title, String primary,
      [String? secondary]) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Raleway_Bold',
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    primary,
                    style: TextStyle(color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: primary));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copied to clipboard', style: TextStyle(fontFamily: 'Raleway'))),
                    );
                  },
                ),
              ],
            ),
            if (secondary != null) ...[
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      secondary,
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: secondary));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied to clipboard',style: TextStyle(fontFamily: 'Raleway'))),
                      );
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dark_2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Center content
          Center(
            child: Image.asset(
              'assets/images/about_us.png',
              width: 450, // Adjust the size as needed
              height: 800, // Adjust the size as needed
            ),
          ),
          // Back button
          Positioned(
            top: 10,
            left: 13,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InviteFriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sampleLink =
        'https://drive.google.com/drive/folders/16NVY1tT6aUSYHXAseZQuMu06NOmxpqw5?usp=drive_link';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Text('Invite Friends',
                style:
                    TextStyle(fontFamily: 'Raleway_Bold', color: Colors.white)),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dark_2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular avatar image
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      AssetImage('assets/images/for_circle_avatar.png'),
                ),
                SizedBox(height: 20),
                // Text
                Text(
                  'Invite your friends with this link:',
                  style: TextStyle(
                      fontFamily: 'Raleway_SemiBold',
                      fontSize: 20,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Link container
                Container(
                  height: 100,
                  width: 350,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SelectableText(
                          sampleLink,
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: Colors.white),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: sampleLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Link copied to clipboard!',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                    ))),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
