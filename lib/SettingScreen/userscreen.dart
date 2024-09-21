import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../UserProvider.dart';
import '../screens/homescreen.dart';

class NetworkMember {
  final String name;
  final int level;

  NetworkMember({required this.name, required this.level});
}

class UserScreen extends StatelessWidget {
  final List<NetworkMember> networkData = [
    NetworkMember(name: 'John Doe', level: 1),
    NetworkMember(name: 'Alice', level: 2),
    NetworkMember(name: 'Bob', level: 2),
    NetworkMember(name: 'Charlie', level: 3),
    NetworkMember(name: 'David', level: 3),
    NetworkMember(name: 'Emma', level: 3),
    NetworkMember(name: 'Frank', level: 4),
    NetworkMember(name: 'Grace', level: 4),
  ];

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserProvider>(context).userDetails;
    // Group network members by their levels
    Map<int, List<NetworkMember>> groupedMembers = {};
    networkData.forEach((member) {
      groupedMembers.putIfAbsent(member.level, () => []);
      groupedMembers[member.level]!.add(member);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white,fontSize: 18),
        title: Text('User Data'),
        iconTheme: IconThemeData(color: Colors.white),leading: IconButton(
        icon: Icon(Icons.arrow_back), // Add back button icon
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>HomeScreen(userDetails: userDetails)));// Navigate back when button is pressed
        },
      ),
      ),
      body: ListView.builder(
        itemCount: groupedMembers.length,
        itemBuilder: (context, index) {
          int level = groupedMembers.keys.elementAt(index);
          List<NetworkMember> members = groupedMembers[level]!;
          return ExpansionTile(
            title: Text('Level $level'),
            children: members.map((member) => ListTile(title: Text(member.name))).toList(),
          );
        },
      ),
    );
  }
}


