import 'package:amethyst/screens/editor_screen/editor_screen.dart';
import 'package:amethyst/screens/home_screen/home_screen.dart';
import 'package:amethyst/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';


class Router {
  static Map<String, Object> params = new Map();
  
  static var routes = <String, WidgetBuilder> {
    '/home_screen': (_) => new HomePage(),
    '/splash_screen': (_) => new SplashScreen(),
    '/editor_screen': (_) => new EditorScreen(params['image']),
  };
}