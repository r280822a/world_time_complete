import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_timezone/flutter_timezone.dart';

class WorldTime {
  String location;
  String flag; // Flag URL
  String url; // URL for API endpoint
  bool isDay = true;
  late Duration offset; // Offset from local time

  // Constructor, requiring each attribute to be explicitly named
  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getOffset() async {
    try {
      // Make request to API
      Response response = await get(Uri.parse("https://worldtimeapi.org/api/timezone/$url"));
      Map data = jsonDecode(response.body);
      
      // Get utc_offset from data
      String locOffsetStr = data["utc_offset"];

      String datetimeStr = data["datetime"];
      datetimeStr = datetimeStr.substring(0, datetimeStr.length - 6);
      datetimeStr = datetimeStr + locOffsetStr;
      DateTime locOffset = DateTime.parse(datetimeStr);
      
      WorldTime currentTimeZone = await getCurrentTimeZone();
      Response currentResponse = await get(Uri.parse("https://worldtimeapi.org/api/timezone/${currentTimeZone.url}"));
      Map currentData = jsonDecode(currentResponse.body);

      // Get currentOffsetSec from data
      String currentOffsetStr = currentData["utc_offset"];

      String curDatetimeStr = data["datetime"];
      curDatetimeStr = curDatetimeStr.substring(0, curDatetimeStr.length - 6);
      curDatetimeStr = curDatetimeStr + currentOffsetStr;
      DateTime currentOffset = DateTime.parse(curDatetimeStr);

      offset = currentOffset.difference(locOffset);
    } catch(e) {
      print("Caught error: $e");
    }
  }
}

Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}

Future<WorldTime> getCurrentTimeZone() async {
  String url = await FlutterTimezone.getLocalTimezone();
  List<String> split = url.split("/");
  String location = split[split.length - 1];
  WorldTime currentTime = WorldTime(location: location, flag: "flag", url: url); 
  return currentTime;
}

Map<String, List<WorldTime>> getAllContinents(List<WorldTime> allLocations) {
  // Returns map with continents and timezones in each continent
  Map<String, List<WorldTime>> allContinents = {};
  
  // Form a key for each continent in allLocations
  for (int i = 0; i < allLocations.length; i++) {
    List<String> split = allLocations[i].url.split("/");
    allContinents[split[0]] = [];
  }

  // Add timezones to each continent
  for (int i = 0; i < allLocations.length; i++) {
    List<String> split = allLocations[i].url.split("/");
    allContinents[split[0]]!.add(allLocations[i]);
  }

  return allContinents;
}

Future<List<WorldTime>> getAllLocations() async {
  // Return list, of type WorldTime, of all timezones

  // Get all URLs and Flags
  List<String> allURLs = await getAllLocationURLs();
  List<String> allCodes = await getAllLocationCodes(allURLs);
  List<String> allFlags = getAllLocationFlags(allCodes);

  List<WorldTime> allLocations = [];
  for (int i = 0; i < allURLs.length; i++) {
    // From URLs, get the location name
    List<String> split = allURLs[i].split("/");
    String locationName = split[split.length - 1];
    locationName = locationName.replaceAll("_", " ");

    allLocations.add(WorldTime(
      location: locationName, 
      flag: allFlags[i], 
      url: allURLs[i]
    ));
  }

  return allLocations;
}

Future<List<String>> getAllLocationURLs() async {
  // Returns list of all URLs, for each timezone
  try {
    // Make request to API
    Response response = await get(Uri.parse("https://worldtimeapi.org/api/timezones"));

    // Reponse body is a string formatted as follows: "["first item", "second item", "third item"]"
    // Clean response body, removing quotes and square brackets
    String responseCleaned = response.body;
    responseCleaned = responseCleaned.replaceAll("\"","");
    responseCleaned = responseCleaned.substring(1, responseCleaned.length - 1);

    // Split the cleaned response to get a list of all URLs
    List<String> allLocations = responseCleaned.split(",");
    
    // Remove all URLs that aren't countries/cities
    List<String> notLocations = [
      "CET", "CST6CDT", "EET", "EST", "EST5EDT",
      "Etc/GMT", "Etc/GMT+1", "Etc/GMT+10", "Etc/GMT+11", "Etc/GMT+12",
      "Etc/GMT+2", "Etc/GMT+3","Etc/GMT+4", "Etc/GMT+5", "Etc/GMT+6",
      "Etc/GMT+7", "Etc/GMT+8", "Etc/GMT+9", "Etc/GMT-1", "Etc/GMT-10",
      "Etc/GMT-11", "Etc/GMT-12", "Etc/GMT-13", "Etc/GMT-14", "Etc/GMT-2",
      "Etc/GMT-3", "Etc/GMT-4", "Etc/GMT-5", "Etc/GMT-6", "Etc/GMT-7",
      "Etc/GMT-8", "Etc/GMT-9", "Etc/UTC", "HST",
      "MET","MST","MST7MDT","PST8PDT", "WET"
    ];
    for (final notLocation in notLocations) {
      allLocations.remove(notLocation);
    }

    return allLocations;
  } catch (e) {
    print("Caught error: $e");
  }
  return ["Could not get data"];
}

Future<List<String>> getAllLocationCodes(List<String> allLocations) async {
  // Returns list of all country codes, for each timezone
  try {
    // Make request to API
    Response response = await get(Uri.parse("https://api.timezonedb.com/v2.1/list-time-zone?key=***REMOVED***&format=json"));
    Map data = jsonDecode(response.body);

    // For each location, find the country code from reponse data
    List<String> allCodes = [];
    for (int i = 0; i < allLocations.length; i++) {
      for (int j = 0; j < data["zones"].length; j++) {
        String zoneName = data["zones"][j]["zoneName"].replaceAll("\\", "");
        if (zoneName == allLocations[i]){
          String countryCode = data["zones"][j]["countryCode"];
          allCodes.add(countryCode.toLowerCase());
        }
      }
    }

    return allCodes;
  } catch(e) {
    print("Caught error: $e");
  }
  return [];
}

List<String> getAllLocationFlags(List<String> allCodes) {
  // Returns list of all flag URLs, for each country code
  List<String> allFlags = [];
  for (int i = 0; i < allCodes.length; i++) {
    allFlags.add("https://flagcdn.com/h80/${allCodes[i]}.png");
  }

  return allFlags;
}
