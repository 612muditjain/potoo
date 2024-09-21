import 'package:flutter/material.dart';
import 'package:potoo/screens/forgotpassword.dart';
import 'package:potoo/screens/homescreen.dart';
import 'package:potoo/screens/loginscreen.dart';
import 'package:potoo/screens/signupscreen.dart';
import 'package:provider/provider.dart';

import 'UserProvider.dart';


// void main() {
//   runApp(MaterialApp(
//
//     debugShowCheckedModeBanner: false,
//     initialRoute: '/',
//     routes: {
//       '/': (context) => SplashScreen(), // Replace with your SplashScreen widget
//       // '/home': (context) => HomeScreen(userDetails: userDetails),
//       '/SignUpPage': (context) => SignUpPage(),
//       '/forgotPassword': (context) => ForgotScreen(),
//       // Add more routes as needed
//     },
//   ));
// }


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(), // Replace with your SplashScreen widget
      // '/home': (context) => HomeScreen(userDetails: userDetails),
      '/SignUpPage': (context) => SignUpPage(),
      '/forgotPassword': (context) => ForgotScreen(),
      '/login': (context) => LoginScreen(),

      // Add more routes as needed
    },
  ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => SignUpPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/logo.jpg'), // Replace 'logo.png' with your image path
            ),
            SizedBox(height: 20),
            Text(
              'POTOO',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//       ),
//       body: Center(
//         child: Text('Welcome to the Home Screen!'),
//       ),
//     );
//   }
// }
