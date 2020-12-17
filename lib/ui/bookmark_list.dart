import 'package:MusicMix/ui/music_details.dart';
import 'package:flutter/material.dart';
import '../bloc/bookmark_bloc.dart';

class BookmarkList extends StatefulWidget {
  static const route = "/bookmarkList";

  @override
  _BookmarkListState createState() => _BookmarkListState();
}

class _BookmarkListState extends State<BookmarkList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bookmarks",
        ),
      ),
      body: FutureBuilder(
        future: bookmarkBloc.getBookmarkList(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length != 0
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: bookmarkBloc.getTrackName(
                            trackID: snapshot.data[index]),
                        builder: (context, nameSnapshot) {
                          if (nameSnapshot.hasData)
                            return InkWell(
                                child: ListTile(
                                  leading: Icon(Icons.music_note),
                                  title: Text(nameSnapshot.data),
                                ),
                                onTap: () {
                                  Navigator.popAndPushNamed(
                                      context, MusicDetails.routeName,
                                      arguments: {
                                        "trackID": snapshot.data[index],
                                        "trackName": nameSnapshot.data,
                                      } as Map);
                                });
                          else {
                            return ListTile(
                              leading: Icon(Icons.music_note),
                              title: Text("Please wait"),
                            );
                          }
                        },
                      );
                    })
                : Center(
                    child: Text("No Bookmarks available"),
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
