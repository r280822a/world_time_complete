import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void setupWorldTime() async {
    // Load Berlin by default
    WorldTime instance = WorldTime(location: "Berlin", flag: "germany.png", url: "Europe/Berlin");
    await instance.getTime();
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/home", arguments: {
        "location": instance.location,
        "flag": instance.flag,
        "time": instance.time,
        "isDay": instance.isDay,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Only ever runs once, when first initalising screen
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Loading screen with fading cube
      backgroundColor: Colors.blue[900],
      body: const Center(
        child: SpinKitFadingCube(
          color: Colors.white,
          size: 80.0,
        ),
      )
    );
  }
}
