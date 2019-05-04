import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:amethyst/screens/editor_screen/widgets/painter/painter_controller.dart';
import 'package:dio/dio.dart';

class MlService {
  static const String _URL = "http://192.168.1.41:5000/";

  Future<File> postImage(PictureDetails image) async {
    var dio = Dio(BaseOptions(
      baseUrl: _URL,
    ));

    try {
      Response response = await dio.post("complete-image", data: { 'img': image.toBase64() });
      print(response.data);
      return response.data;
    }  on DioError catch (e) { 
      print(e.response.data.toString());
    }
  }
}