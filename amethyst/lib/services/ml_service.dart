import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';

class MlService {
  static const String _URL = "http://192.168.1.41:5000/";

  Future<File> postImage(Uint8List image) async {
    var dio = Dio(BaseOptions(
      baseUrl: _URL,
    ));


    var formData = FormData.from({
      "name": "image",
      "image": UploadFileInfo.fromBytes(image, "image.jpg")
    });
    try {
      Response response = await dio.post("complete-image", data: formData);
      print(response.data);
      return response.data;
    }  on DioError catch (e) { 
      print(e.response.data.toString());
    }
  }
}