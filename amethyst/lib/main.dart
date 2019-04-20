import 'package:amethyst/router.dart';
import 'package:amethyst/screens/home_screen/home_screen.dart';
import 'package:amethyst/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

main() => runApp(new MaterialApp(
  home: new SplashScreen(),
  routes: Router.routes,
));
