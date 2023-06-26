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

Future<List<String>> getAllLocationsURL() async {
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

Future<List<String>> getAllLocationsFlag(List<String> allCodes) async {
  List<String> allFlags = [];
  for (int i = 0; i < allCodes.length; i++) {
    allFlags.add("https://flagcdn.com/h80/${allCodes[i]}.png");
  }

  return allFlags;
}



Future<Map> getAllLocationsCountry(List<String> allLocations) async {
  try {
    // Response res = await post(Uri.parse("https://countriesnow.space/api/v0.1/countries"), body: {"city":"Bissau"});
    // print(res);
    // Response response = await get(Uri.parse("https://countriesnow.space/api/v0.1/countries"));
    Response response = await get(Uri.parse("https://countriesnow.space/api/v0.1/countries"));
    // Map data = jsonDecode(res.body);
    print(response.body);
    
    // List<String> allLocationCountries = [];
    // for (var i = 0; i < allLocations.length; i++){
    //   List<String> split = allLocations[i].split("/");
    //   if (split[1] == "Abidjan"){
    //     // Explicitly add country
    //     allLocationCountries.add("Côte d'Ivoire (Ivory Coast)");
    //   } else if (split[1] == "Cairo") {
    //     // Explicitly add country
    //     allLocationCountries.add("British Indian Ocean Territory");
    //   } else if (split[1] == "Chagos") {
    //     // Explicitly add country
    //     allLocationCountries.add("British Indian Ocean Territory");
    //   } else if (split[1] == "Apia") {
    //     // Explicitly add country
    //     allLocationCountries.add("Samoa");
    //   } else if (split[1] == "Apia") {
    //     // Explicitly add country
    //     allLocationCountries.add("Samoa");
      
    //   } else if (split[0] == "Africa" || split[0] == "Asia" || split[0] == "Atlantic" ||  split[0] == "Europe"){
    //     allLocationCountries.add(data[split[1]]);
    //   } else if (split[1] == "Argentina") {
    //     allLocationCountries.add(split[1]);
    //   } else if (split[0] == "America" || split[0] == "Antarctica" || split[0] == "Australia" ||  split[0] == "Maldives" || split[0] == "Mauritius") {
    //     allLocationCountries.add(split[0]);
    //   }
    // }
  } catch(e) {
    print("Caught error: $e");
  }
  return {};
}

Future<Map> getAllLocationsCode() async {
  try {
    Response response = await get(Uri.parse("https://flagcdn.com/en/codes.json"));
    Map data = jsonDecode(response.body);
    print(data);

    Map dataCleaned = {for (var e in data.values.toSet()) e : data.keys.where((k) => data[k] == e)};
    print(dataCleaned);
    
    return dataCleaned;
  } catch (e) {
    print("Caught error: $e");
  }
  return {};
}
