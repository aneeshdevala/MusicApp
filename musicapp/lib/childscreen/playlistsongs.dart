import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';

import 'package:musicapp/Database/favoritebtn.dart';
import 'package:musicapp/Database/playlsitsongdb.dart';
import 'package:musicapp/childscreen/addsongs.dart';
import 'package:musicapp/childscreen/nowplaying.dart';
import 'package:musicapp/getsongstorage.dart';

import 'package:musicapp/model/musicplayer.dart';

import 'package:on_audio_query/on_audio_query.dart';

class PlaylistData extends StatefulWidget {
  const PlaylistData(
      {Key? key, required this.playlist, required this.folderindex})
      : super(key: key);
  final MusicPlayer playlist;
  final int folderindex;
  static List<SongModel> playlistSongid = [];
  @override
  State<PlaylistData> createState() => _PlaylistDataState();
}

class _PlaylistDataState extends State<PlaylistData> {
  late List<SongModel> playlistsong;
  @override
  Widget build(BuildContext context) {
    getAllPlaylist();
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFDD4C4C), Color.fromARGB(255, 233, 211, 211)],
            stops: [0.5, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back)),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: SafeArea(
                child: Column(
              children: [
                Lottie.asset(
                  //  'assets/52011-dj-mixer (1).json',

                  'assets/56301-marriage-couple-hugging (1).json',
                  // 'assets/5880-speaker-headphones.json',
                  height: 150,
                  width: 150,
                ),
                Text(widget.playlist.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.transparent),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => SongListPage(
                                playlist: widget.playlist,
                              )));
                    },
                    child: const Text('Add Songs')),
                ValueListenableBuilder(
                  valueListenable:
                      Hive.box<MusicPlayer>('playlistDB').listenable(),
                  builder: (BuildContext context, Box<MusicPlayer> value,
                      Widget? child) {
                    playlistsong = listPlaylist(
                        value.values.toList()[widget.folderindex].songIds);
                    PlaylistData.playlistSongid = playlistsong;

                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (ctx, index) {
                          return ListTile(
                              onTap: () {
                                List<SongModel> newlist = [...playlistsong];

                                GetSongs.player.stop();
                                GetSongs.player.setAudioSource(
                                    GetSongs.createSongList(newlist),
                                    initialIndex: index);
                                GetSongs.player.play();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => NowPlay(
                                          playerSong: playlistsong,
                                        )));
                              },
                              leading: QueryArtworkWidget(
                                id: playlistsong[index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note,
                                ),
                                errorBuilder: (context, excepion, gdb) {
                                  setState(() {});
                                  return Image.asset('');
                                },
                              ),
                              title: Text(
                                playlistsong[index].title,
                                style: const TextStyle(fontSize: 15),
                              ),
                              subtitle: Text(
                                playlistsong[index].artist!,
                                style: const TextStyle(color: Colors.black),
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (builder) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Color(0xFFDD4C4C),
                                                    Color.fromARGB(
                                                        255, 233, 211, 211)
                                                  ],
                                                  stops: [0.5, 1],
                                                ),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25.0),
                                                    topRight:
                                                        Radius.circular(25.0))),
                                            child: SizedBox(
                                              height: 350,
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    height: 150,
                                                    width: 150,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors
                                                                .transparent),
                                                    child: QueryArtworkWidget(
                                                        artworkBorder:
                                                            BorderRadius
                                                                .circular(1),
                                                        artworkWidth: 100,
                                                        artworkHeight: 400,
                                                        nullArtworkWidget:
                                                            const Icon(
                                                          Icons.music_note,
                                                          size: 100,
                                                        ),
                                                        id: playlistsong[index]
                                                            .id,
                                                        type:
                                                            ArtworkType.AUDIO),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      playlistsong[index].title,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            18.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ElevatedButton.icon(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    primary: Colors
                                                                        .white),
                                                            onPressed: () {
                                                              widget.playlist
                                                                  .deleteData(
                                                                      playlistsong[
                                                                              index]
                                                                          .id);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .delete_outline_outlined,
                                                              size: 25,
                                                            ),
                                                            label: const Text(
                                                              'Remove Song',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20,
                                                              ),
                                                            )),
                                                        Row(
                                                          children: [
                                                            FavoriteBut(
                                                              song:
                                                                  playlistsong[
                                                                      index],
                                                            ),
                                                            const Text(
                                                              'Add to Favorite',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.more_vert_sharp,
                                    color: Colors.black,
                                  )));
                        },
                        separatorBuilder: (ctx, index) {
                          return const Divider();
                        },
                        itemCount: playlistsong.length);
                  },
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < GetSongs.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetSongs.songscopy[i].id == data[j]) {
          plsongs.add(GetSongs.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
}
