import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {}; // Map for a given location
  // late Timer _timer;
  String time = "";

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) => _update());
  }

  void _update() async {
    DateTime dateTime = DateTime.now();
    dateTime = dateTime.add(data["instance"].offset);

    setState(() {
      time = DateFormat.jm().format(dateTime);
      data["isDay"] = (dateTime.hour > 6 && dateTime.hour < 20) ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If empty, recieve map from loading screen
    if (data.isNotEmpty == false){
      data = ModalRoute.of(context)!.settings.arguments as Map;
      _update();
    }

    // Set background
    String bgImage = data["isDay"] ? "day.png" : "night.png";
    Color? bgColor = data["isDay"] ? Colors.blue : Colors.indigo[700];


    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          // Background Image
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/$bgImage"),
              fit: BoxFit.cover,
            ),
          ),
          
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
            child: Column(
              children: [
                // Edit location button
                TextButton.icon(
                  onPressed: () async {
                    // List of all timezones
                    List<WorldTime> allLocations = await getAllTimezones(context);

                    if (mounted && allLocations.isNotEmpty) {
                      // Open choose_location screen, sending timezones, and wait for reponse
                      dynamic result = await Navigator.pushNamed(context, "/location", arguments: {
                        "locations": allLocations,
                      });

                      // If timezone selected, change home screen location
                      if (result != null){
                        setState(() {
                          data = {
                            "instance": result["instance"],
                            "time": result["time"],
                            "location": result["location"],
                            "isDay": result["isDay"],
                            "flag": result["flag"],
                          };
                        });
                      }
                    }
                  }, 
                  icon: const Icon(Icons.edit_location), 
                  label: const Text("Edit location"),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey[300]),
                ),
                const SizedBox(height: 20),
          
                // Location name + time
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data["location"], 
                      style: const TextStyle(
                        fontSize: 28, 
                        letterSpacing: 2, 
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
        
                Text(
                  time,
                  style: const TextStyle(fontSize: 66, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
