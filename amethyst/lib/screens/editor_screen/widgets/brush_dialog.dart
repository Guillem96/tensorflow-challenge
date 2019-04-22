import 'package:amethyst/screens/editor_screen/widgets/painter/painter_controller.dart';
import 'package:flutter/material.dart';

class BrushThicknessDialog extends StatefulWidget {
  final PainterController _controller;

  BrushThicknessDialog(this._controller);

  _BrushThicknessDialogState createState() => _BrushThicknessDialogState();
}

class _BrushThicknessDialogState extends State<BrushThicknessDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.brush,
            size: 30 + 2 * widget._controller.thickness,
          ),
        ),
        Slider(
          activeColor: Colors.deepPurpleAccent,
          inactiveColor: Colors.deepPurple[100],
          value: widget._controller.thickness,
          min: 0.0,
          max: 20.0,
          onChanged: (double vlaue) {
            setState(() {
              widget._controller.thickness = vlaue;
            });
          },
        )
      ],
    );
  }
}
