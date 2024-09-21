import 'package:flutter/material.dart';

class SocialAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text('Social Account Settings'),
      ),
    body: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Colors.black45], // Adjust colors as needed
      ),
    ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Social Account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SocialAccountTile(
              icon: Icons.facebook,
              accountName: 'Facebook',
            ),
            SocialAccountTile(
              icon: Icons.whatshot,
              accountName: 'Whatshot',
            ),
            SocialAccountTile(
              icon: Icons.email_outlined,
              accountName: 'Email',
            ),
            // Add more social account tiles as needed
          ],
        ),
      ),
    ),
      bottomNavigationBar: BottomAppBar(
      color: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Working on this page...',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic,color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class SocialAccountTile extends StatelessWidget {
  final IconData icon;
  final String accountName;

  const SocialAccountTile({
    required this.icon,
    required this.accountName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white70,
            title: Text('Social Account'),
            content: Text('Working on this page...'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
      child: ListTile(
        leading: Icon(icon),
        title: Text(accountName),
      ),
    );
  }
}
