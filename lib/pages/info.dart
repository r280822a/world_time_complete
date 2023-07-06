import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:world_time/services/all_locations.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  ListTile getLinkTile(String link, String title) {
    return ListTile(
      onTap: () async {
        try {
          await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
        } catch (e) {
          showAlertDialog(context, "$e");
          print("Caught error: $e");
        }
      },
      title: Text(title),
      subtitle: Text(link),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("About"),
        elevation: 0,
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),
          const Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.blue,
              ),
              Icon(
                Icons.public,
                color: Colors.greenAccent,
                size: 149,
              ),
              Icon(
                Icons.schedule_outlined,
                color: Color.fromRGBO(250, 250, 250, 1),
                size: 150,
              ),
            ],
          ),

          ListTile(
            onTap: () {},
            title: const Text(
              "World Time",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            subtitle: const Text(
              "v1.7.1",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
          ),

          getLinkTile(
            "https://github.com/r280822a/world_time_complete", 
            "GitHub Repo"
          ),
          getLinkTile(
            "https://github.com/iamshaunjp/flutter-beginners-tutorial", 
            "Original GitHub Repo"
          ),
          getLinkTile(
            "https://github.com/r280822a/world_time_complete#apis", 
            "APIs used: TimeZoneDB, Flagcdn"
          ),
        ],
      ),
    );
  }
}