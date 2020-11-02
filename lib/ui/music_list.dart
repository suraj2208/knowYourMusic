import 'package:MusicMix/bloc/connectivity_bloc.dart';
import 'package:MusicMix/bloc/music_bloc.dart';
import 'package:MusicMix/models/music_model.dart';
import 'package:MusicMix/ui/music_details.dart';
import 'package:flutter/material.dart';

class MusicList extends StatefulWidget {
  static const routeName = "/MusicList";

  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  @override
  Widget build(BuildContext context) {
    bloc.fetchMusic(); //Function Call to sink data from api to stream
    connectivityBloc
        .connectivityStatus(); //Function Call to sink connectivity status to stream
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Trending",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: StreamBuilder(
          stream:
              connectivityBloc.connectivityStatusCode, //Stream for connectivity
          builder: (context, AsyncSnapshot connectivitySnapshot) {
            return StreamBuilder(
              stream: bloc.music, //Stream for track data
              builder: (context, AsyncSnapshot<MusicModel> snapshot) {
                if (snapshot.hasData) {
                  return musicListUI(
                      snapshot: snapshot,
                      connectivitySnapshot:
                          connectivitySnapshot); //Track List Widget
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        ));
  }

  Widget musicListUI(
      {AsyncSnapshot<MusicModel> snapshot,
      AsyncSnapshot connectivitySnapshot}) {
    return connectivitySnapshot.data == 2
        ? Center(
            child: Text("No Internet Connection"),
          )
        : ListView.separated(
            itemCount: snapshot.data.message.body.trackList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(MusicDetails.routeName,
                      arguments: snapshot
                          .data.message.body.trackList[index].track.trackId);
                },
                leading: Icon(Icons.my_library_music_rounded),
                title: Text(
                  snapshot.data.message.body.trackList[index].track.trackName,
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                  snapshot.data.message.body.trackList[index].track.albumName,
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Container(
                  child: Center(
                    child: Text(
                      snapshot
                          .data.message.body.trackList[index].track.artistName,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  height: double.infinity,
                  width: 50,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
  }
}
