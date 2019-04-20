import 'package:amethyst/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';


class Router {
  static Map<String, String> params = new Map();
  
  static var routes = <String, WidgetBuilder> {
    // '/quiz_page': (_) => new QuizPage(),
    '/home_screen': (_) => new HomePage(),
    // '/score_page': (_) => new ScorePage(total: int.parse(params['total']), correct: int.parse(params['correct']))
  };
}