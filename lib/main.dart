import 'package:flutter/material.dart';
import 'package:world_time/pages/choose_location.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/info.dart';

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

  void changeTheme(ThemeMode themeMode) {
    // Change theme from any context using "of" accessor
    setState(() {
      _themeMode = themeMode;
    });
  }
  String getTheme() {
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
