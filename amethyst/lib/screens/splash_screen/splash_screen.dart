import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() { 
    super.initState();
    Timer(Duration(seconds: 2), () => {
      Navigator.of(context).popAndPushNamed("/home_screen")
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.deepPurpleAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 100.0),
            child: Icon(FontAwesomeIcons.brain, size: 120.0, color: Colors.white),
          ),
          Text("Amethyst", style: TextStyle(color: Colors.white, fontSize: 50.0)),
          Text("The intelligent photo editor", style: TextStyle(color: Colors.white, fontSize: 20.0)),
        ],
      ),
    );
  }
}