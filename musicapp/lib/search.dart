import 'package:flutter/material.dart';

import 'package:musicapp/childscreen/nowplaying.dart';
import 'package:musicapp/homescreen.dart';

import 'package:on_audio_query/on_audio_query.dart';

import 'getsongstorage.dart';

ValueNotifier<List<SongModel>> temp = ValueNotifier([]);

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: TextField(
            autofocus: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search)),
            onChanged: (String? value) {
              if (value != null && value.isNotEmpty) {
                temp.value.clear();
                for (SongModel item in HomeScreen.song) {
                  if (item.title.toLowerCase().contains(value.toLowerCase())) {
                    temp.value.add(item);
                  }
                }
              }
              temp.notifyListeners();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ValueListenableBuilder(
                  valueListenable: temp,
                  builder: (BuildContext context, List<SongModel> songData,
                      Widget? child) {
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final data = songData[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ListTile(
                              leading: QueryArtworkWidget(
                                  nullArtworkWidget: const Icon(
                                    Icons.music_note_outlined,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  artworkFit: BoxFit.cover,
                                  id: data.id,
                                  type: ArtworkType.AUDIO),
                              title: Text(
                                data.title,
                                style: const TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                final searchIndex = creatSearchIndex(data);
                                FocusScope.of(context).unfocus();
                                GetSongs.player.setAudioSource(
                                    GetSongs.createSongList(HomeScreen.song),
                                    initialIndex: searchIndex);
                                GetSongs.player.play();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) =>
                                        NowPlay(playerSong: HomeScreen.song)));
                              },
                            ),
                          );
                        },
                        separatorBuilder: (ctx, index) {
                          return const Divider();
                        },
                        itemCount: temp.value.length);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  int? creatSearchIndex(SongModel data) {
    for (int i = 0; i < HomeScreen.song.length; i++) {
      if (data.id == HomeScreen.song[i].id) {
        return i;
      }
    }
    return null;
  }
}
