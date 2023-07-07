import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:world_time/services/all_locations.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<WorldTime> locations = [];

  void updateTime(WorldTime instance) async {
    // Navigate to homescreen
    if (mounted) {
      Navigator.pop(context, {
        "instance": instance,
        "location": instance.location,
        "isDay": instance.isDay,
      });
    }
  }

  List<Widget> buildExpandableContent(String continent, Map<String, List<WorldTime>> allLocationContinents) {
    // To build what goes inside the ExpansionTile
    List<Widget> timezonesInContinent = []; // List of timezones in a given continent

    for (int i = 0; i < allLocationContinents[continent]!.length; i++) {
      // Add a ListTile for each timezone in the given continent
      List<WorldTime> timezone = allLocationContinents[continent]!;
      timezonesInContinent.add(
        ListTile(
          onTap: () {
            updateTime(timezone[i]);
          },
          title: Text(timezone[i].location),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(timezone[i].flag),
          ),
        ),
      );
    }

    return timezonesInContinent;
  }


  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    locations = data["locations"]; // List of timezones

    // Get all continents and the timezones in each continent
    Map<String, List<WorldTime>> allLocationContinents = getAllContinents(locations);
    // List of just continents
    List<String> allContinents = allLocationContinents.keys.toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("Choose a location"),
        elevation: 0,
      ),

      // Cards for each location
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
                  children: buildExpandableContent(allContinents[index], allLocationContinents),
                ),
              ],
            );
          })
        ),
      )
    );
  }
}
