import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicapp/model/musicplayer.dart';
import 'package:musicapp/playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

//playlist songs created

ValueNotifier<List<MusicPlayer>> playlistnotifier = ValueNotifier([]);

Future<void> playlistAdd(MusicPlayer value) async {
  final playListDb = await Hive.openBox<MusicPlayer>('playlistDB');
  final id = await playListDb.add(value);
  value.id = id;
  playlistnotifier.value.add(value);
  playlistnotifier.notifyListeners();
}

Future<void> getAllPlaylist() async {
  final playListDb = await Hive.openBox<MusicPlayer>('playlistDB');
  playlistnotifier.value.clear();
  playlistnotifier.value.addAll(playListDb.values);

  playlistnotifier.notifyListeners();
}

Future<void> playlistDelete(int index) async {
  final playListDb = await Hive.openBox<MusicPlayer>('playlistDB');
  // playListDb.delete(index);
  // playlistnotifier.value.removeWhere((song) => song.id == index);
  // playlistnotifier.notifyListeners();
  await playListDb.deleteAt(index);
  getAllPlaylist();
}
