import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; 

class WorldTime {
  String location;
  String time = "";
  String flag;
  String url;
  bool isDay = true;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    // make request
    try {
      Response response = await get(Uri.parse("https://worldtimeapi.org/api/timezone/$url"));
      Map data = jsonDecode(response.body);
      // print(data);
      
      // get properties from data
      String datetime = data["datetime"];
      datetime = datetime.substring(0, datetime.length - 6);
      DateTime now = DateTime.parse(datetime);

      // set properties
      isDay = (now.hour > 6 && now.hour < 20) ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      print("Caught error: $e");
      time = "Could not get time data";
    }
  }
}