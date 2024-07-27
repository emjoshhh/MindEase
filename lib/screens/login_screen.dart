import 'package:flutter/material.dart';
import '../utils/validators.dart';
import '../screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => LoginScreen(
                  isDarkMode: false,
                  onToggleDarkMode: (bool value) {},
                )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/mindease_logo.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleDarkMode;

  LoginScreen({required this.isDarkMode, required this.onToggleDarkMode});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful!',
              style: TextStyle(
                fontFamily: 'Raleway',
              )),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            isDarkMode: widget.isDarkMode,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please check your credentials.',
              style: TextStyle(
                fontFamily: 'Raleway',
              )),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 60, // Adjust the radius as needed
                backgroundImage: AssetImage('assets/images/mindease_logo.png'),
              ),
              SizedBox(height: 30),
              Text(
                'MindEase',
                style: TextStyle(
                  fontFamily: 'Raleway_Bold',
                  fontSize: 24,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please log in to continue.',
                style: TextStyle(
                  fontFamily: 'Raleway_SemiBold',
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) => _login(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: Validators.validatePassword,
                        onFieldSubmitted: (_) => _login(),
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontFamily: 'Raleway_SemiBold',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 16.0)),
                          minimumSize: MaterialStateProperty.all(
                              Size(double.infinity, 0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
