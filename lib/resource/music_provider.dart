import 'package:MusicMix/models/lyrics_model.dart';
import 'package:MusicMix/models/musicDetail_model.dart';
import 'package:http/http.dart' as http;
import '../models/music_model.dart';

class MusicProvider {
  //First API call
  Future<MusicModel> fetchMusic() async {
    print("Calling Api");
    try {
      final response = await http.get(
          "https://api.musixmatch.com/ws/1.1/chart.tracks.get?country=in&apikey=f45a24f0c5c345f7554954cc0de7f3df");

      print(response.statusCode);

      if (response.statusCode == 200) {
        final musicData = musicModelFromJson(response.body);
        return musicData;
      } else {
        throw Exception("Failed to load");
      }
    } catch (e) {
      return (e);
    }
  }

// Second API call
  Future<MusicDetailsModel> fetchMusicDetails({var trackID}) async {
    print("Calling Api");
    try {
      final response = await http.get(
          "https://api.musixmatch.com/ws/1.1/track.get?track_id=$trackID&apikey=f45a24f0c5c345f7554954cc0de7f3df");

      print(response.statusCode);

      if (response.statusCode == 200) {
        final musicData = musicDetailsModelFromJson(response.body);
        return musicData;
      } else {
        throw Exception("Failed to load");
      }
    } catch (e) {
      return (e);
    }
  }

//Third API call
  Future<LyricsModel> fetchMusicLyrics({var trackID}) async {
    print("Calling Api");
    try {
      final response = await http.get(
          "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackID&apikey=f45a24f0c5c345f7554954cc0de7f3df");

      print(response.statusCode);

      if (response.statusCode == 200) {
        final musicData = lyricsModelFromJson(response.body);
        return musicData;
      } else {
        throw Exception("Failed to load");
      }
    } catch (e) {
      return (e);
    }
  }
}
