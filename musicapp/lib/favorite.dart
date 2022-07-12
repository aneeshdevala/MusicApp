import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/Database/favoritedb.dart';
import 'package:musicapp/childscreen/nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();

  static ConcatenatingAudioSource createSongList(List<SongModel> song) {
    List<AudioSource> source = [];
    for (var songs in song) {
      source.add(AudioSource.uri(Uri.parse(songs.uri!)));
    }
    return ConcatenatingAudioSource(children: source);
  }

  playSong(String? uri) {
    try {
      //song might be currepted so using exception
      audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri!),
        ),
      );
      audioPlayer.play();
    } on Exception {
      log("Error parsing song");
    }
  }

  @override
  Widget build(BuildContext context) {
    FavoriteDB.favoriteSongs.notifyListeners();
    return ValueListenableBuilder(
        valueListenable: FavoriteDB.favoriteSongs,
        builder: (BuildContext ctx, List<SongModel> favorData, Widget? child) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFFDD4C4C),
                Color.fromARGB(255, 255, 255, 255)
              ], stops: [
                0.5,
                1
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Favorites',
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: FavoriteDB.favoriteSongs.value.isEmpty
                    ? const Center(
                        child: Text(
                          'No Song Found',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      )
                    : ValueListenableBuilder(
                        valueListenable: FavoriteDB.favoriteSongs,
                        builder: (BuildContext ctx, List<SongModel> favorData,
                            Widget? child) {
                          return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (ctx, index) {
                                return ListTile(
                                  onTap: () {
                                    FavoriteDB.favoriteSongs.notifyListeners();
                                    List<SongModel> newlist = [...favorData];
                                    setState(() {});
                                    audioPlayer.setAudioSource(
                                        createSongList(newlist),
                                        initialIndex: index);
                                    audioPlayer.play();
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (ctx) => NowPlay(
                                                  songModel: favorData,
                                                  song: newlist,
                                                  index: index,
                                                  audioPlayer: audioPlayer,
                                                )));
                                  },
                                  leading: QueryArtworkWidget(
                                    id: favorData[index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget:
                                        const Icon(Icons.music_note_outlined),
                                  ),
                                  title: Text(
                                    favorData[index].title,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  subtitle: Text(
                                    favorData[index].artist!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        FavoriteDB.favoriteSongs
                                            .notifyListeners();
                                        FavoriteDB.delete(favorData[index].id);
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.heart_broken_sharp)),
                                );
                              },
                              separatorBuilder: (ctx, index) {
                                return const Divider();
                              },
                              itemCount: favorData.length);
                        },
                      ),
              ),
            ),
          );
        });
  }
}
