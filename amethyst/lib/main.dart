import 'package:amethyst/router.dart';
import 'package:amethyst/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

main() => runApp(new MaterialApp(
  home: new HomePage(),
  routes: Router.routes,
));
