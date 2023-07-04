import 'package:flutter/material.dart';

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
    // Initalise variables
    DateTime wantedDatetime = DateTime.now();
    DateTime localDatetime = wantedDatetime;

    // Get local date time
    localDatetime = DateTime.fromMillisecondsSinceEpoch(localTimestamp * 1000);

    // Get wanted date time
    wantedDatetime = DateTime.fromMillisecondsSinceEpoch(wantedTimestamp * 1000);

    // Offset is the difference between local timezone and wanted timezone
    offset = wantedDatetime.difference(localDatetime);
    return "";
  }
}
