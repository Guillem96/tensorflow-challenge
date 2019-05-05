import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:amethyst/screens/editor_screen/widgets/painter/painter_controller.dart';
import 'package:dio/dio.dart';

class MlService {
  static const String _URL = "https://shrouded-refuge-72036.herokuapp.com/";

  Future<File> postImage(PictureDetails image) async {
    var dio = Dio(BaseOptions(
      baseUrl: _URL,
    ));

    String imageData = await image.toBase64();
    try {

      Response response = await dio.post("complete-image", data: { 'img': imageData });
      print(response.statusCode.toString());
      final base64Image = response.data['predict'];
      final tmpPath = (await getApplicationDocumentsDirectory()).path;
      final file = await File('$tmpPath/tmp.jpg').writeAsBytes(base64Decode(base64Image));
      return file;
    }  on DioError catch (e) { 
      print(e.toString());
    }
    return null;
  }
}