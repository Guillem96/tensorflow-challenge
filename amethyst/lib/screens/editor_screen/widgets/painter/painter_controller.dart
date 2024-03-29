import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/material.dart';

class PainterController extends ChangeNotifier {
  Color _drawColor = Color.fromARGB(255, 255, 0, 255);
  Color _backgroundColor = Color.fromARGB(255, 255, 255, 255);

  double _thickness = 1.0;
  PictureDetails _cached;
  PathHistory _pathHistory;
  ValueGetter<Size> _widgetFinish;

  PainterController() {
    _pathHistory = PathHistory();
  }

  ValueGetter<Size> get widgetFinish => _widgetFinish;
  set widgetFinish(finished) => _widgetFinish = finished;
  
  PathHistory get pathHistory => _pathHistory;

  Color get drawColor => _drawColor;
  set drawColor(Color color) {
    _drawColor = color;
    _updatePaint();
  }

  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color color) {
    _backgroundColor = color;
    _updatePaint();
  }

  double get thickness => _thickness;
  set thickness(double t) {
    _thickness = t;
    _updatePaint();
  }

  void _updatePaint() {
    Paint paint = Paint();
    paint.color = drawColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = thickness;
    _pathHistory.currentPaint = paint;
    _pathHistory.setBackgroundColor(backgroundColor);
    notifyListeners();
  }

  void undo() {
    if (!isFinished()) {
      _pathHistory.undo();
      notifyListeners();
    }
  }

  void notify() {
    notifyListeners();
  }

  void clear() {
    if (!isFinished()) {
      _pathHistory.clear();
      notifyListeners();
    }
  }

  Future<PictureDetails> finish(File image) async {
    if (!isFinished()) {
      _cached = await _render(_widgetFinish(), image);
    }
    return _cached;
  }

  Future<PictureDetails> _render(Size size, File file) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    ui.Image image = await decodeImageFromList(await file.readAsBytes());
    canvas.drawImageRect(
      image, 
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
    );
    _pathHistory.draw(canvas, size);
    return PictureDetails(
        recorder.endRecording(), size.width.floor(), size.height.floor());
  }

  bool isFinished() {
    return _cached != null;
  }
}


typedef PictureDetails PictureCallback();

class PictureDetails {
  final ui.Picture picture;
  final int width;
  final int height;

  const PictureDetails(this.picture, this.width, this.height);

  Future<ui.Image> toImage() async {
    return await picture.toImage(width, height);
  }

  Future<Uint8List> toPNG() async {
    var image = await toImage();
    
    return (await image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<String> toBase64() async {
    var image = await toPNG();
    return base64Encode(image);
  }
}


class PathHistory {
  List<MapEntry<Path, Paint>> _paths;
  Paint currentPaint;
  Paint _backgroundPaint;
  bool _inDrag;

  PathHistory() {
    _paths = List<MapEntry<Path, Paint>>();
    _inDrag = false;
    _backgroundPaint = Paint();
  }

  void setBackgroundColor(Color backgroundColor) {
    _backgroundPaint.color = backgroundColor;
  }

  void undo() {
    if (!_inDrag) {
      _paths.removeLast();
    }
  }

  void clear() {
    if (!_inDrag) {
      _paths.clear();
    }
  }

  void add(Offset startPoint) {
    if (!_inDrag) {
      _inDrag = true;
      Path path = Path();
      path.moveTo(startPoint.dx, startPoint.dy);
      _paths.add(MapEntry<Path, Paint>(path, currentPaint));
    }
  }

  void updateCurrent(Offset nextPoint) {
    if (_inDrag) {
      Path path = _paths.last.key;
      path.lineTo(nextPoint.dx, nextPoint.dy);
    }
  }

  void endCurrent() {
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height), _backgroundPaint);
    for (MapEntry<Path, Paint> path in _paths) {
      canvas.drawPath(path.key, path.value);
    }
  }
}