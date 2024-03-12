import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:lightbulb/util/colors.dart';
import 'package:lightbulb/util/create_material_color.dart';
import '../analytics.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  initState() {
    super.initState();
    setCurrentScreen(widget.analytics, 'Messages Page', 'messagesPage');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Column(
        children: [
          Text("Messages"),
          OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/editprofile');
              },
              child: Text('press'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ))
        ],
      ),
    ));
  }
}
