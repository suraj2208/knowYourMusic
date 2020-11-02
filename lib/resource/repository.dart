import 'package:MusicMix/models/lyrics_model.dart';
import 'package:MusicMix/models/musicDetail_model.dart';
import 'package:MusicMix/models/music_model.dart';
import 'package:MusicMix/resource/music_provider.dart';

//Repository for data from API calls
class Repository {
  final musicProvider = MusicProvider();
  Future<MusicModel> fetchMusic() => musicProvider.fetchMusic();
  Future<MusicDetailsModel> fetchMusicDetails({trackID}) =>
      musicProvider.fetchMusicDetails(trackID: trackID);
  Future<LyricsModel> fetchMusicLyrics({trackID}) =>
      musicProvider.fetchMusicLyrics(trackID: trackID);
}
