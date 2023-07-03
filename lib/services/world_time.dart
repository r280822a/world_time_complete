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

  Future<String> getOffset(BuildContext context) async {
    // Gets offset for wanted timezone (the timezone specified in url attribute)
    try {
      // Make request to API for wanted timezone
      Response response = await get(Uri.parse("https://worldtimeapi.org/api/timezone/$url"));
      Map data = jsonDecode(response.body);
      // Get current datetime at wanted timezone
      String datetimeStr = data["datetime"];
      // Remove the offset at the end of datetime
      // e.g. remove '+01:00' from '2023-07-03T15:51:58.519684+01:00'
      datetimeStr = datetimeStr.substring(0, datetimeStr.length - 6);

      // Get offset, from wanted timezone
      String wantedOffsetStr = data["utc_offset"];
      // wantedDatetime is datetime + [offset at wanted timezone]
      String wantedDatetimeStr = datetimeStr + wantedOffsetStr;
      DateTime wantedDatetime = DateTime.parse(wantedDatetimeStr);
      
      // Make request to API for local timezone
      WorldTime localTimeZone = await getLocalTimeZone();
      Response localResponse = await get(Uri.parse("https://worldtimeapi.org/api/timezone/${localTimeZone.url}"));
      Map localData = jsonDecode(localResponse.body);

      // Get offset, from local timezone
      String localOffsetStr = localData["utc_offset"];
      // localDatetime is datetime + [offset at local timezone]
      String localDatetimeStr = datetimeStr + localOffsetStr;
      DateTime localDatetime = DateTime.parse(localDatetimeStr);

      // Offset is the difference between local timezone and wanted timezone
      offset = localDatetime.difference(wantedDatetime);
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
