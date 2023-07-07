import 'package:flutter/material.dart';
import 'package:world_time/pages/choose_location.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/loading.dart';
import 'package:world_time/pages/info.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      /* light theme settings */
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      /* dark theme settings */
    ),
    themeMode: ThemeMode.dark, 
    /* ThemeMode.system to follow system theme, 
        ThemeMode.light for light theme, 
        ThemeMode.dark for dark theme
    */
    routes: {
      "/": (context) => Loading(),
      "/home": (context) => Home(),
      "/location":(context) => ChooseLocation(),
      "/info":(context) => Info(),
    },
  ));
}
