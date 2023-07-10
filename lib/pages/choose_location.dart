import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:world_time/services/all_locations.dart';
import 'package:world_time/services/helper_widgets.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<WorldTime> timezones = [];

  void updateTime(WorldTime instance) async {
    // Navigate to homescreen
    if (mounted) {
      Navigator.pop(context, {
        "instance": instance,
        "timezone": instance.timezone,
        "isDay": instance.isDay,
      });
    }
  }

  List<Widget> buildExpandableContent(String continent, Map<String, List<WorldTime>> allContinentsMap) {
    // To build what goes inside the ExpansionTile

    // List of timezone ListTiles
    List<Widget> timezoneTiles = [];

    for (int i = 0; i < allContinentsMap[continent]!.length; i++) {
      // Add a ListTile for each timezone in the given continent
      List<WorldTime> timezone = allContinentsMap[continent]!;
      timezoneTiles.add(
        ListTile(
          onTap: () {
            updateTime(timezone[i]);
          },
          title: Text(timezone[i].timezone),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(timezone[i].flag),
          ),
        ),
      );
    }

    return timezoneTiles;
  }

  @override
  void initState() {
    super.initState();
    // Only ever runs once, when first initalising screen
    getTimezones();
  }

  void getTimezones() async {
    // Get all timezones, then rebuild
    timezones = await getAllTimezones(context);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    if (timezones.isEmpty) {return getLoadingScreen();}

    // Get all continents and the timezones in each continent
    Map<String, List<WorldTime>> allContinentsMap = getAllContinents(timezones);
    // List of just continents
    List<String> allContinents = allContinentsMap.keys.toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("Choose a location"),
        elevation: 0,
      ),

      // Expandable continent tile, revealing cards for each timezone
      body: Container(
        color: Theme.of(context).cardColor,
        child: ListView.builder(
          itemCount: allContinents.length,
          itemBuilder: ((context, index) {
            return ExpansionTile(
              title: Text(allContinents[index]),
              backgroundColor: Theme.of(context).cardColor,
              collapsedBackgroundColor: Theme.of(context).cardColor,
              children: <Widget>[
                Column(
                  children: buildExpandableContent(
                    allContinents[index], 
                    allContinentsMap
                  ),
                ),
              ],
            );
          })
        ),
      )
    );
  }
}
