import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

List<WorldTime> allTimezones = [];

Future<List<WorldTime>> getAllTimezones(BuildContext context) async {
  // Return list of all timezones

  if (allTimezones.isNotEmpty){
    return allTimezones;
  }

  try {
    // Make request to API
    Response response = await get(Uri.parse("https://api.timezonedb.com/v2.1/list-time-zone?key=***REMOVED***&format=json"));
    Map data = jsonDecode(response.body);

    for (int i = 0; i < data["zones"].length; i++){
      String url = data["zones"][i]["zoneName"].replaceAll("\\", "");
      String flag = data["zones"][i]["countryCode"].toLowerCase();
      flag = "https://flagcdn.com/h80/$flag.png";

      List<String> split = url.split("/");
      String locationName = split[split.length - 1];
      locationName = locationName.replaceAll("_", " ");

      allTimezones.add(WorldTime(
        location: locationName, 
        flag: flag, 
        url: url
      ));

      // Get local date time
      WorldTime localTimeZone = await getLocalTimeZone();
      Response localResponse = await get(Uri.parse("http://api.timezonedb.com/v2.1/get-time-zone?key=***REMOVED***&format=json&by=zone&zone=${localTimeZone.url}"));
      Map localData = jsonDecode(localResponse.body);
      int localTimestamp = localData["timestamp"];
      
      int wantedTimestamp = data["zones"][i]["timestamp"];
      allTimezones[i].getOffset(context, localTimestamp, wantedTimestamp);
    }
  } catch(e) {
    showAlertDialog(context, "$e");
    print("Caught error: $e");
    return [];
  }

  return allTimezones;
}


Future<WorldTime> getLocalTimeZone() async {
  // Returns a WorldTime object specifying the local timezone
  String url = await FlutterTimezone.getLocalTimezone();
  List<String> split = url.split("/");
  String location = split[split.length - 1];
  WorldTime localTimezone = WorldTime(location: location, flag: "", url: url); 
  return localTimezone;
}

Map<String, List<WorldTime>> getAllContinents(List<WorldTime> allTimezones) {
  // Returns map with continents and timezones in each continent
  Map<String, List<WorldTime>> allContinents = {};

  // Form a key for each continent in allTimezones
  for (int i = 0; i < allTimezones.length; i++) {
    List<String> split = allTimezones[i].url.split("/");
    allContinents[split[0]] = [];
  }

  // Add timezones to each continent
  for (int i = 0; i < allTimezones.length; i++) {
    List<String> split = allTimezones[i].url.split("/");
    allContinents[split[0]]!.add(allTimezones[i]);
  }

  return allContinents;
}

showAlertDialog(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Make sure you're connected to the internet"),
      content: Text(error),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        )
      ],
    ),
  );
}
