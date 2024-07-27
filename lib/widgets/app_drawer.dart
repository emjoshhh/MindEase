import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/app_drawer_landing.dart';
import '../screens/login_screen.dart';

class AppDrawer extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleDarkMode;

  AppDrawer({required this.isDarkMode, required this.onToggleDarkMode});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _totalDurationSpent = 0;
  int _startButtonPressCount = 0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalDurationSpent = prefs.getInt('totalDurationSpent') ?? 0;
      _startButtonPressCount = prefs.getInt('startButtonPressCount') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app_drawer_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 150,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/app_drawer_background.jpg'),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.6),
                                BlendMode.dstATop,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.black,
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/for_circle_avatar.png',
                                    fit: BoxFit.cover,
                                    width: 55,
                                    height: 55,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Josh Tumbaga',
                                style: TextStyle(
                                  fontFamily: 'Raleway_SemiBold',
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'tumbebi@gmail.com',
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 10,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade900,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/app_drawer_background.jpg'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.6),
                                    BlendMode.dstATop,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.self_improvement,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '$_startButtonPressCount sessions',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'of breath',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade900,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/app_drawer_background.jpg'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.6),
                                    BlendMode.dstATop,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.lock_clock,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '${_totalDurationSpent ~/ 60} min',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'of breathing',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  _buildListTile(
                    context,
                    icon: Icons.account_circle,
                    title: 'Account',
                    targetPage: AccountScreen(),
                  ),
                  Divider(),
                  _buildListTile(
                    context,
                    icon: Icons.support,
                    title: 'Support',
                    targetPage: SupportScreen(), 
                  ),
                  Divider(),
                  _buildListTile(
                    context,
                    icon: Icons.person_add,
                    title: 'Invite Friends',
                    targetPage: InviteFriendsPage(),
                  ),
                  Divider(),
                  _buildListTile(
                    context,
                    icon: Icons.info,
                    title: 'About Us',
                    targetPage: AboutUsPage(),
                  ),
                  Divider(),
                  _buildListTile(
                    context,
                    icon: Icons.logout,
                    title: 'Log Out',
                    targetPage: LoginScreen(
                      isDarkMode: widget.isDarkMode,
                      onToggleDarkMode: widget.onToggleDarkMode,
                    ),
                    replace: true,
                  ),
                  Divider(),
                ],
              ),
            ),
            Spacer(),
            SwitchListTile(
              title: Text('Dark Mode',
                  style: TextStyle(fontFamily: 'Raleway', color: Colors.white)),
              value: widget.isDarkMode,
              onChanged: (value) {
                widget.onToggleDarkMode(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required Widget targetPage,
      bool replace = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title,
          style:
              TextStyle(fontFamily: 'Raleway_SemiBold', color: Colors.white)),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => targetPage,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
    );
  }
}
