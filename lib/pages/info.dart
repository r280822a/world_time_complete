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
          ListTile(
            onTap: () {},
            title: const Text("Version"),
            subtitle: const Text("1.7.0"),
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
            "https://github.com/r280822a/world_time_complete#readme", 
            "APIs used: TimeZoneDB, Flagcdn"
          ),
        ],
      ),
    );
  }
}