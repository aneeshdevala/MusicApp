import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:musicapp/Model/musicplayer.dart';
import 'package:musicapp/View/SplashScreen/splashscreen.dart';

//playlist songs created
class PlayListDb extends ChangeNotifier {
  List<MusicPlayer> playlistnotifier = [];

  Future<void> playlistAdd(MusicPlayer value) async {
    final playListDb = Hive.box<MusicPlayer>('playlistDB');
    await playListDb.add(value);
    getAllPlaylist();
    notifyListeners();
  }

  Future<void> getAllPlaylist() async {
    final playListDb = Hive.box<MusicPlayer>('playlistDB');

    playlistnotifier.clear();
    playlistnotifier.addAll(playListDb.values);

    notifyListeners();
  }

  Future<void> playlistDelete(int index) async {
    final playListDb = Hive.box<MusicPlayer>('playlistDB');

    await playListDb.deleteAt(index);
    getAllPlaylist();
    notifyListeners();
  }

  Future<void> appReset(context) async {
    final playListDb = Hive.box<MusicPlayer>('playlistDB');
    final musicDb = Hive.box<int>('favoriteDB');
    await musicDb.clear();
    await playListDb.clear();
    musicDb.clear();
    notifyListeners();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false);
  }

  notifyListeners();
}
