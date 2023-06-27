import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  // List<WorldTime> locations = [
  //   WorldTime(url: 'Europe/London', location: 'London', flag: 'uk.png'),
  //   WorldTime(url: 'Europe/Athens', location: 'Athens', flag: 'greece.png'),
  //   WorldTime(url: 'Africa/Cairo', location: 'Cairo', flag: 'egypt.png'),
  //   WorldTime(url: 'Africa/Nairobi', location: 'Nairobi', flag: 'kenya.png'),
  //   WorldTime(url: 'America/Chicago', location: 'Chicago', flag: 'usa.png'),
  //   WorldTime(url: 'America/New_York', location: 'New York', flag: 'usa.png'),
  //   WorldTime(url: 'Asia/Seoul', location: 'Seoul', flag: 'south_korea.png'),
  //   WorldTime(url: 'Asia/Jakarta', location: 'Jakarta', flag: 'indonesia.png'),
  // ];

  List<WorldTime> locations = [];

  void updateTime(index) async {
    WorldTime instance = locations[index];
    await instance.getTime();
    
    // Navigate to homescreen
    if (mounted) {
      Navigator.pop(context, {
        "location": instance.location,
        "flag": instance.flag,
        "time": instance.time,
        "isDay": instance.isDay,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    locations = data["locations"];
    Map<String, List<WorldTime>> allLocationContenants = getAllContenants(locations);
    List<String> allContenants = allLocationContenants.keys.toList();
    
    buildExpandableContent(String contenant) {
      List<Widget> columnContent = [];

      for (int i = 0; i < allLocationContenants[contenant]!.length; i++) {
        List<WorldTime> location = allLocationContenants[contenant]!;
        columnContent.add(
          ListTile(
            onTap: () {
              updateTime(i);
            },
            title: Text(location[i].location),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(location[i].flag),
            ),
          ),
        );
      }

      return columnContent;
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("Choose a location"),
        elevation: 0,
      ),

      body: ListView.builder(
        itemCount: allContenants.length,
        itemBuilder: ((context, index) {
          return ExpansionTile(
            title: Text(allContenants[index]),
            children: <Widget>[
              Column(
                children: buildExpandableContent(allContenants[index]),
              ),
            ],
          );
        })
      )
      
      // Cards for each location
      // body: ListView.builder(
      //   itemCount: locations.length,
      //   itemBuilder: ((context, index) {
      //     return Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      //       child: Card(
      //         child: ListTile(
      //           onTap: () {
      //             updateTime(index);
      //           },
      //           title: Text(locations[index].location),
      //           leading: CircleAvatar(
      //             backgroundImage: NetworkImage(locations[index].flag),
      //           ),
      //         ),
      //       ),
      //     );
      //   })
      // )
    );
  }
}
