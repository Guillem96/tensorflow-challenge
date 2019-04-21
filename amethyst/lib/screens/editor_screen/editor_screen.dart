import 'dart:io';
import 'dart:typed_data';

import 'package:amethyst/screens/editor_screen/widgets/painter/draw_bar.dart';
import 'package:amethyst/screens/editor_screen/widgets/painter/painter.dart';
import 'package:amethyst/screens/editor_screen/widgets/painter/painter_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditorScreen extends StatefulWidget {
  final File _image;

  EditorScreen(this._image);
  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  bool _finished;
  PainterController _controller;

  @override
  void initState() {
    super.initState();
    _finished = false;
    _controller = controller;
  }

  PainterController get controller {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.content_copy),
          tooltip: ' Painting',
          onPressed: () => setState(() {
            _finished = false;
            _controller = controller;
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.undo),
          tooltip: 'Undo',
          onPressed: _controller.undo
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: 'Clear',
          onPressed: _controller.clear
        ),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () async => _show(await _controller.finish(widget._image), context)
        ),
      ];
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painter Example'),
        actions: actions,
        backgroundColor: Colors.purpleAccent,
        bottom: PreferredSize(
          child: DrawBar(_controller),
          preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
        )
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration( 
            image: DecorationImage(
              image: FileImage(widget._image),
              fit: BoxFit.cover,
            ),
          ),
          child: Painter(_controller)
        )
      )
    );
  }

  void _show(PictureDetails picture, BuildContext context) {
    setState(() {
      _finished = true;
    });
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
}