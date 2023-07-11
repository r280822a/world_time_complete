import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:world_time/services/world_time.dart';
import 'package:world_time/services/all_locations.dart';
import 'package:world_time/services/helper_widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late WorldTime displayTimezone;
  bool loading = true;
  String time = "";
  bool is24Hour = false;

  @override
  void initState() {
    super.initState();
    setupLocalTime();
    Fluttertoast.showToast(
        msg: "Tap the time to change to 24 hour format, and vice versa",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }

  void setupLocalTime() async {
    // Load local time by default
    displayTimezone = await getLocalTimeZone();
    displayTimezone.offset = const Duration(seconds: 0);
    _update();
    
    Timer.periodic(const Duration(seconds: 1), (timer) => _update());
    setState(() {
      loading = false;
    });
  }

  void _update() async {
    // Updates time, every second
    DateTime dateTime = DateTime.now();
    dateTime = dateTime.add(displayTimezone.offset);

    if (mounted) {
      setState(() {
        if (is24Hour){
          time = DateFormat.Hm().format(dateTime);
        } else{
          time = DateFormat.jm().format(dateTime);
        }
        displayTimezone.isDay = (dateTime.hour > 6 && dateTime.hour < 20) ? true : false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (loading) {return getLoadingScreen("Home");}

    // Set background
    String bgImage = displayTimezone.isDay ? "day.png" : "night.png";
    Color? bgColor = displayTimezone.isDay ? const Color(0xff1288c8) : const Color(0xff282761);

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
          
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                // Info page icon
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/info");
                      }, 
                      icon: const Icon(Icons.info_outline),
                      color: Colors.grey[300],
                      iconSize: 25,
                    ),
                  ),
                ),

                const SizedBox(height: 110),

                // Edit location button, launching choose_location
                TextButton.icon(
                  onPressed: () async {
                    if (mounted) {
                      // Open choose_location screen, sending timezones, and wait for reponse
                      dynamic result = await Navigator.pushNamed(context, "/location");

                      // If timezone selected, change home screen timezone
                      if (result != null){
                        setState(() {
                          displayTimezone = result["instance"];
                        });
                      }
                    }
                  }, 
                  icon: const Icon(Icons.edit_location), 
                  label: const Text("Edit location"),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey[300]),
                ),
                const SizedBox(height: 20),
          
                // Timezone name + time
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      displayTimezone.timezone, 
                      style: const TextStyle(
                        fontSize: 28, 
                        letterSpacing: 2, 
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
        
                GestureDetector(
                  onTap: () {
                    is24Hour = !is24Hour;
                  },
                  child: Text(
                    time,
                    style: const TextStyle(fontSize: 66, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
