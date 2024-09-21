import 'package:flutter/material.dart';
import 'package:potoo/Question/question.dart';
import 'package:potoo/UserProvider.dart';
import 'package:potoo/drawerscreen/notificatonscreen.dart';
import 'package:potoo/drawerscreen/sharescreen.dart';
import 'package:potoo/historyofbankbalance.dart';
import 'package:potoo/pages/FIfthPage.dart';
import 'package:potoo/pages/FirstPage.dart';
import 'package:potoo/pages/FourthPage.dart';
import 'package:potoo/pages/SecondPage2.dart';
import 'package:potoo/pages/ThirdPage.dart';
import 'package:potoo/SettingScreen/privacypolicyscreen.dart';
import 'package:potoo/screens/loginscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../drawerscreen/settingscreen.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  HomeScreen({required this.userDetails});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final Question placeholderQuestion = Question(
    id: 'placeholder',
    question: 'This is a placeholder question',
    options: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
    correctAnswer: 'Option 1',
  );

  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();

    // Defer the state update until after the build process
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).setUserDetails(widget.userDetails);
      final userDetails = Provider.of<UserProvider>(context, listen: false).userDetails;
      final String userId = userDetails['_id'] ?? '';
      final String questionId = userDetails['_id'] ?? '';

      setState(() {
        _tabs = [
          FirstPage(userId: userId,),
          QuizScreen(questionId: questionId, userId: userId),
          ThirdPage(userId: userId),
          FourthPage(userId: userId),
          FifthPage(userId: userId),
        ];
      });
    });

    // Initialize _tabs with placeholders to avoid null errors
    _tabs = [
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
    ];
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<bool> onWillPop() async {
    // Prevent back navigation
    return Future.value(false);
  }

  Future<bool> _onBackPressed() async {
    // Intercept back button press
    SystemNavigator.pop();
    return true; // Return true to allow back button press
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserProvider>(context).userDetails;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black26,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
          title: Text('Potoo'),
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.circle_notifications_outlined),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NotificationScreen(
                  userId: userDetails['_id'] ?? '', // Replace with actual userId retrieval logic
                  level: 1,
                )));
              },
            ),
            IconButton(
              icon: Icon(Icons.share),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReferralScreen()));
              },
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.black45],
            ),
          ),
          child: _tabs[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.black, // Color when item is selected
          unselectedItemColor: Colors.grey, // Color when item is not selected
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.share_rounded),
              label: 'Share',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.connect_without_contact),
              label: 'Network',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white70,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black45,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/logo.jpg'), // Provide your image path here
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userDetails['username']}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${userDetails['email']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${userDetails['phoneNumber']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${userDetails['referralCode']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${userDetails['plan']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.currency_rupee_sharp),
                title: Text('Wallet Transaction'),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalletHistory( userId: userDetails['_id'] ?? '',)));
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NotificationScreen(
                    userId: userDetails['_id'] ?? '', // Replace with actual userId retrieval logic
                    level: 1, )));
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                onTap: () {
                  // Navigate to help screen
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.privacy_tip_outlined),
                title: Text('Privacy and Policy'),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
