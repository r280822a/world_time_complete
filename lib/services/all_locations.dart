import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';

List<WorldTime> allTimezones = [];

Future<List<WorldTime>> getAllTimezones(BuildContext context) async {
  // Return list of all timezones

  if (allTimezones.isNotEmpty){
    return allTimezones;
  }

  // Get all URLs and Flags
  List<String> allURLs = await getAllTimezoneURLs();
  if (context.mounted && allURLs[0] == "Could not get data"){
    showAlertDialog(context, allURLs[1]);
    return [];
  }
  List<String> allCodes = await getAllTimezoneCodes(allURLs);
  if (context.mounted && allCodes[0] == "Could not get data"){
    showAlertDialog(context, allCodes[1]);
    return [];
  }
  List<String> allFlags = getAllTimezoneFlags(allCodes);

  for (int i = 0; i < allURLs.length; i++) {
    // From URLs, get the location name
    List<String> split = allURLs[i].split("/");
    String locationName = split[split.length - 1];
    locationName = locationName.replaceAll("_", " ");

    allTimezones.add(WorldTime(
      location: locationName, 
      flag: allFlags[i], 
      url: allURLs[i]
    ));
  }

  return allTimezones;
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


Future<List<String>> getAllTimezoneURLs() async {
  // Returns list of URLs, for each timezone
  Object error;
  try {
    // Make request to API
    Response response = await get(Uri.parse("https://worldtimeapi.org/api/timezones"));

    // Reponse body is a string formatted as follows: "["first item", "second item", "third item"]"
    // Clean response body, removing quotes and square brackets
    String responseCleaned = response.body;
    responseCleaned = responseCleaned.replaceAll("\"","");
    responseCleaned = responseCleaned.substring(1, responseCleaned.length - 1);

    // Split the cleaned response to get a list of all URLs
    List<String> allURLs = responseCleaned.split(",");
    
    // Remove all URLs that aren't countries/cities
    List<String> notURLs = [
      "CET", "CST6CDT", "EET", "EST", "EST5EDT",
      "Etc/GMT", "Etc/GMT+1", "Etc/GMT+10", "Etc/GMT+11", "Etc/GMT+12",
      "Etc/GMT+2", "Etc/GMT+3","Etc/GMT+4", "Etc/GMT+5", "Etc/GMT+6",
      "Etc/GMT+7", "Etc/GMT+8", "Etc/GMT+9", "Etc/GMT-1", "Etc/GMT-10",
      "Etc/GMT-11", "Etc/GMT-12", "Etc/GMT-13", "Etc/GMT-14", "Etc/GMT-2",
      "Etc/GMT-3", "Etc/GMT-4", "Etc/GMT-5", "Etc/GMT-6", "Etc/GMT-7",
      "Etc/GMT-8", "Etc/GMT-9", "Etc/UTC", "HST",
      "MET","MST","MST7MDT","PST8PDT", "WET"
    ];
    for (final notURL in notURLs) {
      allURLs.remove(notURL);
    }

    return allURLs;
  } catch (e) {
    error = e;
    print("Caught error: $e");
  }
  return ["Could not get data", "$error"];
}

Future<List<String>> getAllTimezoneCodes(List<String> allTimezone) async {
  // Returns list of country codes, for each timezone
  Object error;
  try {
    // Make request to API
    Response response = await get(Uri.parse("https://api.timezonedb.com/v2.1/list-time-zone?key=***REMOVED***&format=json"));
    Map data = jsonDecode(response.body);

    // For each timezone, find the country code from reponse data
    List<String> allCodes = [];
    for (int i = 0; i < allTimezone.length; i++) {
      for (int j = 0; j < data["zones"].length; j++) {
        String zoneName = data["zones"][j]["zoneName"].replaceAll("\\", "");
        if (zoneName == allTimezone[i]){
          String countryCode = data["zones"][j]["countryCode"];
          allCodes.add(countryCode.toLowerCase());
        }
      }
    }

    return allCodes;
  } catch(e) {
    error = e;
    print("Caught error: $e");
  }
  return ["Could not get data", "$error"];
}

List<String> getAllTimezoneFlags(List<String> allCodes) {
  // Returns list of flag URLs, for each country code
  List<String> allFlags = [];
  for (int i = 0; i < allCodes.length; i++) {
    allFlags.add("https://flagcdn.com/h80/${allCodes[i]}.png");
  }

  return allFlags;
}
