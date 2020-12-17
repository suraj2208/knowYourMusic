import 'package:MusicMix/ui/bookmark_list.dart';
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
      theme: ThemeData(
          brightness: Brightness.dark, primaryColorDark: Colors.black54),
      debugShowCheckedModeBanner: false,
      //First Screen
      home: MusicList(),
      routes: {
        MusicDetails.routeName: (context) => MusicDetails(), //Detail Screen
        MusicList.routeName: (context) => MusicList(), //Main Screen
        BookmarkList.route: (context) => BookmarkList(), //Bookmark List
      },
    );
  }
}
