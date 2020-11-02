import 'package:flutter/material.dart';
import "./ui/music_list.dart";
import "./ui/music_details.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //First Screen
      home: MusicList(),
      routes: {
        MusicDetails.routeName: (context) => MusicDetails(), //Detail Screen
        MusicList.routeName: (context) => MusicList(), //Main Screen
      },
    );
  }
}
