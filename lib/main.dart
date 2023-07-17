import 'package:flutter/material.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/choose_location.dart';
import 'package:world_time/pages/info.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  // InheritedWidget style accessor to our State object
  static _MyAppState of(BuildContext context) => 
    context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // themeMode "state" field
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      routes: {
        "/": (context) => const Home(),
        "/location":(context) => const ChooseLocation(),
        "/info":(context) => const Info(),
      },
    );
  }

  void changeThemeString(String themeString) async {
    // Change theme from any context using "of" accessor
    
    ThemeMode themeMode = _themeMode;
    switch (themeString) {
      case "Light": 
        themeMode = ThemeMode.light;
        break;
      case "Dark": 
        themeMode = ThemeMode.dark;
        break;
      case "System Default": 
        themeMode = ThemeMode.system;
        break;
    }

    setState(() {
      _themeMode = themeMode;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', getThemeString());
  }
  String getThemeString() {
    // Return string based on _themeMode
    switch (_themeMode) {
      case ThemeMode.light:
        return "Light";
      case ThemeMode.dark:
        return "Dark";
      case ThemeMode.system:
        return "System Default";
    }
  }
}
