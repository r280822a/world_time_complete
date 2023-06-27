import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; 

class WorldTime {
  String location;
  String time = "";
  String flag; // Flag URL
  String url; // URL for API endpoint
  bool isDay = true;

  // Constructor, requiring each attribute to be explicitly named
  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      // Make request to API
      Response response = await get(Uri.parse("https://worldtimeapi.org/api/timezone/$url"));
      Map data = jsonDecode(response.body);
      
      // Get datetime from data
      String datetime = data["datetime"];
      datetime = datetime.substring(0, datetime.length - 6);
      DateTime now = DateTime.parse(datetime);

      // Set attributes
      isDay = (now.hour > 6 && now.hour < 20) ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      print("Caught error: $e");
      time = "Could not get time data";
    }
  }
}

Future<List<WorldTime>> getAllLocations() async {
  List<String> allURLs = await getAllLocationURLs();
  List<String> allCodes = await getAllLocationCodes(allURLs);
  List<String> allFlags = await getAllLocationFlags(allCodes);

  List<WorldTime> allLocations = [];

  for (int i = 0; i < allURLs.length; i++) {
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
  try {
    Response response = await get(Uri.parse("https://worldtimeapi.org/api/timezones"));

    String responseCleaned = response.body;
    responseCleaned = responseCleaned.replaceAll("\"","");
    responseCleaned = responseCleaned.substring(1, responseCleaned.length - 1);

    List<String> allLocations = responseCleaned.split(",");
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
  try {
    Response response = await get(Uri.parse("https://api.timezonedb.com/v2.1/list-time-zone?key=***REMOVED***&format=json"));
    Map data = jsonDecode(response.body);

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

Future<List<String>> getAllLocationFlags(List<String> allCodes) async {
  List<String> allFlags = [];
  for (int i = 0; i < allCodes.length; i++) {
    allFlags.add("https://flagcdn.com/h80/${allCodes[i]}.png");
  }

  return allFlags;
}
