import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/material.dart';
import 'package:world_time/services/all_locations.dart';

class WorldTime {
  String location;
  String flag; // Flag URL
  String url; // URL for API endpoint
  bool isDay = true;
  late Duration offset; // Offset from local time

  // Constructor, requiring each attribute to be explicitly named
  WorldTime({required this.location, required this.flag, required this.url});

  Future<String> getOffset(BuildContext context, int localTimestamp, int wantedTimestamp) async {
    // Gets offset for wanted timezone (the timezone specified in url attribute)
    try {
      // Get local timezone
      // WorldTime localTimeZone = await getLocalTimeZone();
      // Initalise variables
      DateTime wantedDatetime = DateTime.now();
      DateTime localDatetime = wantedDatetime;

      // Get local date time
      // Response localResponse = await get(Uri.parse("http://api.timezonedb.com/v2.1/get-time-zone?key=***REMOVED***&format=json&by=zone&zone=${localTimeZone.url}"));
      // Map localData = jsonDecode(localResponse.body);
      localDatetime = DateTime.fromMillisecondsSinceEpoch(localTimestamp * 1000);

      // Get wanted date time
      // Response wantedResponse = await get(Uri.parse("http://api.timezonedb.com/v2.1/get-time-zone?key=***REMOVED***&format=json&by=zone&zone=$url"));
      // Map wantedData = jsonDecode(wantedResponse.body);
      wantedDatetime = DateTime.fromMillisecondsSinceEpoch(wantedTimestamp * 1000);

      // Offset is the difference between local timezone and wanted timezone
      offset = wantedDatetime.difference(localDatetime);
    } catch(e) {
      showAlertDialog(context, "$e");
      print("Caught error: $e");
      return "Could not get data";
    }
    return "";
  }
}



Future<WorldTime> getLocalTimeZone() async {
  // Returns a WorldTime object specifying the local timezone
  String url = await FlutterTimezone.getLocalTimezone();
  List<String> split = url.split("/");
  String location = split[split.length - 1];
  WorldTime localTimezone = WorldTime(location: location, flag: "", url: url); 
  return localTimezone;
}
