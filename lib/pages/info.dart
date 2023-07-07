import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:world_time/services/all_locations.dart';
import 'package:world_time/main.dart';

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
          await launchUrl(
            Uri.parse(link),
            mode: LaunchMode.externalApplication
          );
        } catch (e) {
          showAlertDialog(context, "$e");
          print("Caught error: $e");
        }
      },
      title: Text(title),
      subtitle: Text(link),
    );
  }

  String theme = "System Default";
  RadioMenuButton getThemeRadioButton(String title){
    return RadioMenuButton(
      value: title,
      groupValue: theme,
      onChanged: (value){
        setState(() {
          theme = title;
          switch (title) {
            case "Light": 
              MyApp.of(context).changeTheme(ThemeMode.light);
              break;
            case "Dark": 
              MyApp.of(context).changeTheme(ThemeMode.dark);
              break;
            case "System Default": 
              MyApp.of(context).changeTheme(ThemeMode.system);
              break;
          }
          Navigator.pop(context);
        });
      },
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
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
          // App Icon
          Stack(
            alignment: Alignment.center,
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.blue,
              ),
              const Icon(
                Icons.public,
                color: Colors.greenAccent,
                size: 140,
              ),
              const Icon(
                Icons.schedule_outlined,
                color: Color.fromRGBO(250, 250, 250, 1),
                size: 140,
              ),
              Icon(
                Icons.circle_outlined,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 150,
              ),
            ],
          ),

          // App Name + Version
          ListTile(
            title: const Text(
              "World Time",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            subtitle: Text(
              "v1.8.0",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),

          // Change theme & rebuild to show it using these buttons
          ListTile(
            title: const Text("Theme"),
            subtitle: Text(theme),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Select Theme"),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    Column(
                      children: [
                        getThemeRadioButton("Light"),
                        getThemeRadioButton("Dark"),
                        getThemeRadioButton("System Default"),
                      ]
                    ),
                  ],
                ),
              );
            },
          ),

          // List tiles for links
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