import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:potoo/QuizScreen.dart';
import 'package:potoo/ratgames.dart';
import '../OfferBoxex.dart';

class FirstPage extends StatelessWidget {
  final String userId;

  FirstPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          CarouselSlider(
            items: [
              Container(
                color: Colors.red,
                child: Center(child: Text('Page 1')),
              ),
              Container(
                color: Colors.blue,
                child: Center(child: Text('Page 2')),
              ),
              Container(
                color: Colors.green,
                child: Center(child: Text('Page 3')),
              ),
            ],
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 2),
              autoPlayAnimationDuration: Duration(milliseconds: 700),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          ),
          SizedBox(height: 20),
          OfferBox(
            title: 'Special Offer 1',
            description: 'Get 20% off on selected items',
            onPressed: () {
              // Add your action here
            },
          ),
          SizedBox(height: 20),
          OfferBox(
            title: 'Special Offer 2',
            description: 'Buy one, get one free!',
            onPressed: () {
              // Add your action here
            },
          ),
          SizedBox(height: 20),
          OfferBox(
            title: 'Special Offer 3',
            description: 'Buy one, get one free!',
            onPressed: () {
              // Add your action here
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizScreen()),
              );
            },
            child: Text('Quiz Game'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RatGamePage(userId: userId)),
              );
            },
            child: Text('Play Rat Game'),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
