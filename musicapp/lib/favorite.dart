import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:musicapp/Database/favoritedb.dart';
import 'package:musicapp/childscreen/nowplaying.dart';
import 'package:musicapp/getsongstorage.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // final OnAudioQuery audioQuery = OnAudioQuery();
  // final AudioPlayer audioPlayer = AudioPlayer();

  static ConcatenatingAudioSource createSongList(List<SongModel> song) {
    List<AudioSource> source = [];
    for (var songs in song) {
      source.add(AudioSource.uri(Uri.parse(songs.uri!)));
    }
    return ConcatenatingAudioSource(children: source);
  }

  // playSong(String? uri) {
  //   try {
  //     //song might be currepted so using exception
  //     audioPlayer.setAudioSource(
  //       AudioSource.uri(
  //         Uri.parse(uri!),
  //       ),
  //     );
  //     audioPlayer.play();
  //   } on Exception {
  //     log("Error parsing song");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: const Text(
                    'Favorites',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  //centerTitle: true,
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: FavoriteDB.favoriteSongs.value.isEmpty
                      ? Center(
                          child: Column(
                          children: [
                            Lottie.asset(
                              'assets/fav.json',
                              height: 200,
                              width: 200,
                            ),
                            const Text(
                              'No favorites yet',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ))
                      : ListView(children: [
                          ValueListenableBuilder(
                            valueListenable: FavoriteDB.favoriteSongs,
                            builder: (BuildContext ctx,
                                List<SongModel> favorData, Widget? child) {
                              return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (ctx, index) {
                                    return ListTile(
                                      onTap: () {
                                        // FavoriteDB.favoriteSongs
                                        //     .notifyListeners();
                                        List<SongModel> newlist = [
                                          ...favorData
                                        ];
                                        setState(() {});
                                        GetSongs.player.setAudioSource(
                                            createSongList(newlist),
                                            initialIndex: index);
                                        GetSongs.player.play();
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (ctx) => NowPlay(
                                                      playerSong: newlist,

                                                      // songModel: favorData,
                                                      // song: newlist,
                                                      // index: index,
                                                      // audioPlayer: audioPlayer,
                                                    )));
                                      },
                                      leading: QueryArtworkWidget(
                                        id: favorData[index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: const Icon(
                                          Icons.music_note_outlined,
                                          size: 35,
                                        ),
                                      ),
                                      title: Text(
                                        favorData[index].title,
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 15),
                                      ),
                                      subtitle: Text(
                                        favorData[index].artist!,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            // FavoriteDB.favoriteSongs
                                            //     .notifyListeners();
                                            FavoriteDB.delete(
                                                favorData[index].id);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.heart_broken_sharp,
                                            size: 30,
                                          )),
                                    );
                                  },
                                  separatorBuilder: (ctx, index) {
                                    return const Divider();
                                  },
                                  itemCount: favorData.length);
                            },
                          ),
                        ]),
                ),
              ),
            ),
          );
        });
  }
}
