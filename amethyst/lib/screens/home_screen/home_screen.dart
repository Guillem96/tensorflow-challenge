import 'package:amethyst/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
              onTap: () =>
                ImagePicker.pickImage(source: ImageSource.camera)
                  .then((image) {
                    Router.params['image'] = image;
                    Navigator.of(context).pushNamed('/editor_screen');
                  }),
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
              onTap: () =>
                ImagePicker.pickImage(source: ImageSource.gallery)
                  .then((image) {
                    Router.params['image'] = image;
                    Navigator.of(context).pushNamed('/editor_screen');
                  }),
              child: Column(
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

Future takeImageAndNavigate() async {
  var image =  await ImagePicker.pickImage(source: ImageSource.camera);
}

Future getImageAndNavigate() async {
  var image = await ImagePicker.pickImage(source: ImageSource.gallery);

}