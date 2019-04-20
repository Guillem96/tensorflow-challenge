import 'package:flutter/material.dart';

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
                  Icon(Icons.photo_camera, color: Colors.white, size: 60.0,),
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
                  Icon(Icons.photo_album, color: Colors.white, size: 60.0,),
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