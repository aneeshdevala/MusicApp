import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:musicapp/childscreen/nowplaying.dart';
import 'package:musicapp/homescreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'getsongstorage.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> searchSongs = [];
  Future<void> getSongs() async {
    searchSongs = await Future.value(_audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true));
  }

  //List<SongModel> allsongs = [];

  List<SongModel> allSongs = [];
  @override
  initState() {
    // at the beginning, all users are shown
    allSongs = searchSongs;

    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all songs
      results = searchSongs;
    } else {
      results = searchSongs
          .where((name) => name.displayNameWOExt
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      allSongs = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    getSongs();
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFDD4C4C), Color.fromARGB(255, 255, 255, 255)],
            stops: [0.5, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 30, right: 20),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Find Your Songs',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      //  autofocus: true,

                      onChanged: (value) => _runFilter(value),
                      decoration: const InputDecoration(
                          labelText: 'Search', suffixIcon: Icon(Icons.search)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    allSongs.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                            itemCount: allSongs.length,
                            itemBuilder: (context, int index) =>
                                GestureDetector(
                              onTap: (() {
                                setState(() {});
                                GetSongs.player.setAudioSource(
                                  GetSongs.createSongList(allSongs),
                                  initialIndex: index,
                                );
                                GetSongs.player.play();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NowPlay(
                                              playerSong: allSongs,
                                            )));
                                setState(() {});

                                // setState(() {});
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) =>
                                //           NowPlay(playerSong: HomeScreen.song
                                //               // song: [allSongs[index]],
                                //               // songModel: [allSongs[index]],
                                //               // index: index,
                                //               // audioPlayer: audioPlayer
                                //               ),
                                //     ));
                              }),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  leading: QueryArtworkWidget(
                                    id: allSongs[index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget:
                                        const Icon(Icons.music_note_outlined),
                                    artworkFit: BoxFit.cover,
                                  ),
                                  title: Text(allSongs[index].displayNameWOExt),
                                ),
                              ),
                            ),
                          ))
                        : Expanded(
                            child: Center(
                              child: Image.asset(
                                  'assets/undraw_Quiz_re_aol4-removebg-preview.png'),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
