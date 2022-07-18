// import 'package:flutter/foundation.dart';
// import 'package:hive/hive.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// //Playlist Folder created
// class PlayList {
//   static bool isInitialized = false;
//   static ValueNotifier<List<SongModel>> folderPlayList = ValueNotifier([]);
//   static final musicDb = Hive.box<int>('playlistDB');
//   static List<String> folderName = [];

//   static initialise(List<SongModel> songs) {
//     for (SongModel song in songs) {
//       if (isPlayList(song)) {
//         folderPlayList.value.add(song);
//       }
//     }
//     isInitialized = true;
//   }

//   static add(SongModel song) async {
//     musicDb.add(song.id);
//     folderPlayList.value.add(song);
//   }

//   static delete(int id) {
//     int deletekey = 0;
//     if (!musicDb.values.contains(id)) {
//       return;
//     }

//     final Map<dynamic, int> favorMap = musicDb.toMap();

//     favorMap.forEach((key, value) {
//       if (value == id) {
//         deletekey = key;
//       }
//     });
//     musicDb.delete(deletekey);
//     folderPlayList.value.removeWhere((song) => song.id == id);
//   }

//   static bool isPlayList(SongModel song) {
//     if (musicDb.values.contains(song.id)) {
//       return true;
//     }
//     return false;
//   }
// }
