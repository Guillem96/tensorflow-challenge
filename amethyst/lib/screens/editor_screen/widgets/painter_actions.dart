import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unicorndial/unicorndial.dart';

class PainterActions extends StatelessWidget {
  final Function onClear;
  final Function onOK;
  final Function onBrushSize;
  final Function onUndo;

  const PainterActions(
    { 
      this.onOK,
      this.onClear,
      this.onBrushSize,
      this.onUndo
    }
  );
  
  @override
  Widget build(BuildContext context) {

    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
      currentButton: FloatingActionButton(
        heroTag: "clear",
        tooltip: "Clear",
        backgroundColor: Colors.redAccent,
        mini: true,
        child: Icon(FontAwesomeIcons.eraser),
        onPressed: onClear,
      )
    ));

    childButtons.add(UnicornButton(
      currentButton: FloatingActionButton(
        heroTag: "ok",
        tooltip: "Done",
        backgroundColor: Colors.greenAccent,
        mini: true,
        onPressed: onOK,
        child: Icon(FontAwesomeIcons.check)
      )
    ));

    childButtons.add(UnicornButton(
      currentButton: FloatingActionButton(
        heroTag: "brush_size",
        tooltip: "Brush size",
        backgroundColor: Colors.blueAccent,
        mini: true,
        onPressed: onBrushSize,
        child: Icon(FontAwesomeIcons.paintBrush)
      )
    ));

    childButtons.add(UnicornButton(
      currentButton: FloatingActionButton(
        heroTag: "undo",
        tooltip: "Undo",
        backgroundColor: Colors.orangeAccent,
        mini: true,
        onPressed: onUndo,
        child: Icon(Icons.undo)
      )
    ));

    return UnicornDialer(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
      parentButtonBackground: Colors.deepPurpleAccent,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(FontAwesomeIcons.palette),
      childButtons: childButtons
    );
  }
}