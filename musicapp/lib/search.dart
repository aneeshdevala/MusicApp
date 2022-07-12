import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicapp/childscreen/nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> searchSongs = [];
  Future<void> getSongs() async {
    searchSongs = await Future.value(_audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true));
  }

  List allSongs = [];
  @override
  initState() {
    // at the beginning, all users are shown
    allSongs = searchSongs;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
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

  // playSong(String? uri) {
  //   try {
  //     //song might be currepted so using exception
  //     audioPlayer.setAudioSource(
  //       AudioSource.uri(Uri.parse(uri!)),
  //     );
  //     audioPlayer.play();
  //   } on Exception {
  //     log("Error parsing song");
  //   }
  // }

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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'MusiFy',
              style: TextStyle(color: Colors.black),
            ),
          ),
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
                    Expanded(
                      child: FutureBuilder<List<SongModel>>(
                        future: _audioQuery.querySongs(
                            sortType: null,
                            orderType: OrderType.ASC_OR_SMALLER,
                            uriType: UriType.EXTERNAL,
                            ignoreCase: true),
                        builder: (context, item) {
                          return ListView.builder(
                            itemCount: allSongs.length,
                            itemBuilder: (context, int index) =>
                                GestureDetector(
                              onTap: (() {
                                setState(() {});
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NowPlay(
                                          song: [allSongs[index]],
                                          songModel: item.data!,
                                          index: index,
                                          audioPlayer: audioPlayer),
                                    ));
                              }),
                              child: Card(
                                // key: ValueKey(allSongs[index]["id"]),
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

                                  // leading: Text(allSongs.toString()),
                                  // title: Text(allSongs[index]['S']),
                                  // subtitle: Text(
                                  //   "${allSongs[index]}",
                                  // ),
                                  title: Text(allSongs[index].displayNameWOExt),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // FloatingActionButton.extended(
                    //   onPressed: () {
                    //     showSearch(context: context, delegate: SearchScreen());
                    //   },
                    //   label: Text("Click to Search"),
                    // )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
