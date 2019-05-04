import 'dart:io';
import 'dart:typed_data';

import 'package:amethyst/screens/editor_screen/widgets/brush_dialog.dart';
import 'package:amethyst/screens/editor_screen/widgets/painter/painter.dart';
import 'package:amethyst/screens/editor_screen/widgets/painter/painter_controller.dart';
import 'package:amethyst/screens/editor_screen/widgets/painter_actions.dart';
import 'package:amethyst/services/ml_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditorScreen extends StatefulWidget {
  final File _image;

  EditorScreen(this._image);
  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {

  double containerWidth;
  double containerHeight;  

  PainterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = controller;
    decodeImageFromList(widget._image.readAsBytesSync()).then(
      (img) {
        double size = MediaQuery.of(context).size.width;

        setState(() {
          containerWidth = size * img.height / img.width;
          containerHeight = size * img.height / img.width;
        });
      });
  }

  PainterController get controller {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painter Example'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Container(
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration( 
            image: DecorationImage(
              image: FileImage(widget._image),
              fit: BoxFit.fill,
            ),
          ),
          child: Painter(_controller, containerWidth, containerHeight)
        )
      ),
      floatingActionButton: PainterActions(
        onBrushSize: _updateBrushThickness,
        onClear: _controller.clear,
        onUndo: _controller.undo,
        onOK: () async {
          var picture = await _controller.finish(widget._image);
          await MlService().postImage(picture);
          _show(picture, context); 
        },
      ),
    );
  }

  void _show(PictureDetails picture, BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('View your image'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: FutureBuilder<Uint8List>(
            future: picture.toPNG(),
            builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Image.memory(snapshot.data);
                  }
                  break;
                default:
                  return Container(
                      child: FractionallySizedBox(
                    widthFactor: 0.1,
                    child: AspectRatio(
                        aspectRatio: 1.0, child: CircularProgressIndicator()),
                    alignment: Alignment.center,
                  )
                );
              }
            },
          )
        ),
      );
    }));
  }

  void _updateBrushThickness() {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Please select brush thickness'),
          actions: <Widget>[
            FlatButton(
              onPressed: (){ Navigator.of(context).pop(); },
              child: Text('Ok', style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20),),
            ),
          ],
          content: SingleChildScrollView(
            child: BrushThicknessDialog(_controller),
          ),
        );
      },
      barrierDismissible: false,
    );
  }
}