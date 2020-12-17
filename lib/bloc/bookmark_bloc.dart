import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkBloc {
  List<String> sampleList = [];
  clearAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    print("clear");
    return preferences.get("bookmarkedTrackList");
  }

  getBookmarkList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> bookmarkedTrackList =
        preferences.getStringList("bookmarkedTrackList");
    if (bookmarkedTrackList == null) {
      preferences.setStringList("bookmarkedTrackList", sampleList);
      bookmarkedTrackList = preferences.get("bookmarkedTrackList");
      return bookmarkedTrackList;
    } else
      return bookmarkedTrackList;
  }

  addBookmark({trackID, trackName, ctx}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> bookmarkedTrackList =
        preferences.getStringList("bookmarkedTrackList");
    if (bookmarkedTrackList == null) {
      preferences.setStringList(
          "bookmarkedTrackList", sampleList); //Making list non-null
      bookmarkedTrackList = preferences
          .getStringList("bookmarkedTrackList"); //getting non-null list
      bookmarkedTrackList.add(trackID); //adding trackID in list
      preferences.setStringList(
          "bookmarkedTrackList", bookmarkedTrackList); //updating List
      preferences.setString(
          trackID, trackName); //setting trackID and trackName pairs

    } else {
      bookmarkedTrackList.add(trackID); //adding trackID in list
      preferences.setStringList(
          "bookmarkedTrackList", bookmarkedTrackList); //updating List
      preferences.setString(
          trackID, trackName); //setting trackID and trackName pairs

    }
  }

  removeBookmark({String trackID, trackName, BuildContext ctx}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> bookmarkedTrackList =
        preferences.getStringList("bookmarkedTrackList");
    bookmarkedTrackList.remove(trackID); //removing trackID from list
    preferences.setStringList(
        "bookmarkedTrackList", bookmarkedTrackList); //updating List
    preferences.remove(trackID); //removing trackID and trackName pairs
  }

  getTrackName({trackID}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var trackName = preferences.get(trackID);
    return trackName;
  }
}

final bookmarkBloc = BookmarkBloc();
