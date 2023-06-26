import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {}; // Map for a given location

  @override
  Widget build(BuildContext context) {
    // If empty, recieve map from loading screen
    data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;

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
                    dynamic result = await Navigator.pushNamed(context, "/location");
                    setState(() {
                      data = {
                        "time": result["time"],
                        "location": result["location"],
                        "isDay": result["isDay"],
                        "flag": result["flag"],
                      };
                    });
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
                  data["time"],
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