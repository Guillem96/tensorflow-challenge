import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Material(
            color: Colors.greenAccent,
            child: InkWell( //> Invisible button, with wave animation
              onTap: () => Navigator.of(context).pushNamed('/home_screen'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FontAwesomeIcons.cameraRetro, color: Colors.white, size: 60.0,),
                  Padding(padding: EdgeInsets.only(bottom: 10),),
                  Text("Take a photo!", style: TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold)),
                ],
              )
            ),
          )
        ),
        Expanded(
          child:Material(
            color: Colors.redAccent,
            child: InkWell( //> Invisible button, with wave animation
              onTap: () => Navigator.of(context).pushNamed('/home_screen'),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FontAwesomeIcons.images, color: Colors.white, size: 60.0,),
                  Padding(padding: EdgeInsets.only(bottom: 10),),
                  Text("Pick a photo!", style: TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold)),
                ],
              )
            ),
          )
        ),
      ],
    );
  }
}