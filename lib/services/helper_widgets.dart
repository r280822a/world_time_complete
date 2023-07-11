import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget getLoadingScreen(title) {
  return Scaffold(
    // Loading screen with fading cube
    backgroundColor: Colors.blue[900],
    appBar: AppBar(
      backgroundColor: Colors.blue[900],
      title: Text(title),
      elevation: 0,
    ),
    body: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpinKitFadingCube(
          color: Colors.white,
          size: 80.0,
        ),
        SizedBox(height: 40),
        Text(
          "Loading...",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        )
      ],
    ),
  );
}

showAlertDialog(BuildContext context, String error) {
  // Shows alert dialog, for errors
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