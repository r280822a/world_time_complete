import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:world_time/services/world_time.dart';
import 'package:world_time/services/helper_widgets.dart';

List<WorldTime> allTimezones = [];

Future<List<WorldTime>> getAllTimezones(BuildContext context) async {
  // Return list of all timezones

  if (allTimezones.length == 418){
    // If allTimezones already has all timezones, return it
    return allTimezones;
  } else {
    allTimezones = [];
  }

  try {
    // Make request to API, get data
    Response response = await get(Uri.parse("https://api.timezonedb.com/v2.1/list-time-zone?key=***REMOVED***&format=json"));
    Map data = jsonDecode(response.body);

    // Get local date time
    String localTimezoneName = await FlutterTimezone.getLocalTimezone();
    Response localResponse = await get(Uri.parse("http://api.timezonedb.com/v2.1/get-time-zone?key=***REMOVED***&format=json&by=zone&zone=$localTimezoneName"));
    Map localData = jsonDecode(localResponse.body);
    int localTimestamp = localData["timestamp"];

    for (int i = 0; i < data["zones"].length; i++){
      // For each timezone in data, add to allTimezones
      String flag = data["zones"][i]["countryCode"].toLowerCase();
      flag = "https://flagcdn.com/h80/$flag.png";

      String zoneName = data["zones"][i]["zoneName"].replaceAll("\\", "");
      List<String> split = zoneName.split("/");

      String timezone = split[split.length - 1];
      timezone = timezone.replaceAll("_", " ");
      String continent = split[0];

      allTimezones.add(WorldTime(
        timezone: timezone, 
        flag: flag, 
        continent: continent
      ));

      // Initialize offset for each timezone
      int wantedTimestamp = data["zones"][i]["timestamp"];
      allTimezones[i].initOffset(localTimestamp, wantedTimestamp);
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
  String zoneName = await FlutterTimezone.getLocalTimezone();
  
  List<String> split = zoneName.split("/");
  String timezone = split[split.length - 1];
  String continent = split[0];

  WorldTime localTimezone = WorldTime(timezone: timezone, flag: "", continent: continent); 
  return localTimezone;
}

Map<String, List<WorldTime>> getAllContinentsMap(List<WorldTime> allTimezones) {
  // Returns map with continents and timezones in each continent
  Map<String, List<WorldTime>> allContinents = {};

  // Form a key for each continent in allTimezones
  for (int i = 0; i < allTimezones.length; i++) {
    allContinents[allTimezones[i].continent] = [];
  }

  // Add timezones to each continent
  for (int i = 0; i < allTimezones.length; i++) {
    allContinents[allTimezones[i].continent]!.add(allTimezones[i]);
  }

  return allContinents;
}
