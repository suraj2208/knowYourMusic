import 'package:MusicMix/bloc/bookmark_bloc.dart';
import 'package:MusicMix/bloc/connectivity_bloc.dart';
import 'package:MusicMix/bloc/musicDetail_bloc.dart';
import 'package:MusicMix/models/lyrics_model.dart';
import 'package:MusicMix/models/musicDetail_model.dart';
import 'package:flutter/material.dart';

class MusicDetails extends StatefulWidget {
  static const routeName = "/MusicDetail";

  @override
  _MusicDetailsState createState() => _MusicDetailsState();
}

class _MusicDetailsState extends State<MusicDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)
        .settings
        .arguments; //Getting trackID from Track list.
    final trackID = args["trackID"];
    final trackName = args["trackName"];
    print("this is args $args");
    print(trackID);
    print(trackName);

    List bookmarkTrackList = [];
    bookmarkBloc.getBookmarkList().then((value) {
      bookmarkTrackList = value;
      print(bookmarkTrackList);
    });

    connectivityBloc
        .connectivityStatus(); //Function Call to sink connectivity status to stream
    musicDetailsbloc.fetchMusicDetails(
        trackID: trackID); //Function Call to sink Second Api data to stream
    musicDetailsbloc.fetchLyrics(
        trackID: trackID); //Function Call to sink Third API data to stream
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: bookmarkTrackList.contains(trackID.toString())
                  ? Icon(
                      Icons.bookmark,
                    )
                  : Icon(Icons.bookmark_border),
            ),
            onTap: () {
              setState(() {
                if (bookmarkTrackList.contains(trackID.toString())) {
                  bookmarkBloc.removeBookmark(
                      trackID: trackID.toString(),
                      trackName: trackName,
                      ctx: context);
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text("Bookmark Removed"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  bookmarkBloc.addBookmark(
                      trackID: trackID.toString(),
                      trackName: trackName,
                      ctx: context);
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text("Bookmark Added"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              });
            },
          )
        ],
        title: Text(
          "Title Details",
        ),
      ),
      body: StreamBuilder(
        stream: connectivityBloc.connectivityStatusCode,
        builder: (context, AsyncSnapshot connectivitySnapshot) {
          return StreamBuilder(
              stream: musicDetailsbloc.musicDetails,
              builder:
                  (context, AsyncSnapshot<MusicDetailsModel> detailSnapshot) {
                return StreamBuilder(
                  stream: musicDetailsbloc.musicLyrics,
                  builder: (context, AsyncSnapshot<LyricsModel> lyricSnapshot) {
                    if (detailSnapshot.hasData && lyricSnapshot.hasData) {
                      return musicDetailsUI(
                          detailSnapshot: detailSnapshot,
                          lyricSnapshot: lyricSnapshot,
                          connectivitySnapshot: connectivitySnapshot,
                          ctx: context);
                    } else if (detailSnapshot.hasError ||
                        lyricSnapshot.hasError) {
                      return Text(detailSnapshot.error.toString());
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              });
        },
      ),
    );
  }

  Widget musicDetailsUI(
      {AsyncSnapshot<MusicDetailsModel> detailSnapshot,
      AsyncSnapshot<LyricsModel> lyricSnapshot,
      AsyncSnapshot connectivitySnapshot,
      ctx}) {
    print(bookmarkBloc
        .getBookmarkList()
        .then((v) => print("Bookmark List is $v")));
    List headings = [
      "Name",
      "Artist",
      "Album Name",
      "Explicit",
      "Lyrics",
    ];
    List data = [
      detailSnapshot.data.message.body.track.trackName,
      detailSnapshot.data.message.body.track.artistName,
      detailSnapshot.data.message.body.track.albumName,
      detailSnapshot.data.message.body.track.explicit.toString(),
      lyricSnapshot.data.message.body.lyrics.lyricsBody,
    ];
    return connectivitySnapshot.data == 2
        ? Center(
            child: Text("No Internet Connection"),
          )
        : ListView.builder(
            itemCount: headings.length,
            itemBuilder: (BuildContext ctx, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headings[index],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data[index],
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              );
            },
          );
  }
}
