
import 'dart:io';

import 'package:amethyst/screens/editor_screen/widgets/image_viewer.dart';
import 'package:flutter/cupertino.dart';

class EditorScreen extends StatefulWidget {
  File image;

  EditorScreen(this.image);

  @override
  State<StatefulWidget> createState() {
    return _EditorScreenState();
  }
}

class _EditorScreenState extends State<EditorScreen> {

  _EditorScreenState();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ImageViewer(widget.image),);
  }
}