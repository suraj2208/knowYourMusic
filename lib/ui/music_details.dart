import 'package:MusicMix/bloc/connectivity_bloc.dart';
import 'package:MusicMix/bloc/musicDetail_bloc.dart';
import 'package:MusicMix/models/lyrics_model.dart';
import 'package:MusicMix/models/musicDetail_model.dart';
import 'package:flutter/material.dart';

class MusicDetails extends StatelessWidget {
  static const routeName = "/MusicDetail";

  @override
  Widget build(BuildContext context) {
    final trackID = ModalRoute.of(context)
        .settings
        .arguments; //Getting trackID from Track list.
    connectivityBloc
        .connectivityStatus(); //Function Call to sink connectivity status to stream
    musicDetailsbloc.fetchMusicDetails(
        trackID: trackID); //Function Call to sink Second Api data to stream
    musicDetailsbloc.fetchLyrics(
        trackID: trackID); //Function Call to sink Third API data to stream
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Title Details",
          style: TextStyle(color: Colors.black),
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
    List headings = ["Name", "Artist", "Album Name", "Explicit", "Lyrics"];
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
            itemCount: 5,
            itemBuilder: (BuildContext ctx, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headings[index],
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
