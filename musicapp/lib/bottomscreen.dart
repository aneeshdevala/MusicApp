import 'package:flutter/material.dart';
import 'package:musicapp/childscreen/miniscreen.dart';
import 'package:musicapp/favorite.dart';
import 'package:musicapp/newbox.dart';
import 'package:musicapp/playlist.dart';
import 'package:musicapp/search.dart';
import 'package:musicapp/widgets/glass.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'Database/favoritedb.dart';
import 'getsongstorage.dart';
import 'homescreen.dart';

class BottomScreens extends StatefulWidget {
  const BottomScreens({Key? key}) : super(key: key);

  @override
  State<BottomScreens> createState() => _BottomScreensState();
}

class _BottomScreensState extends State<BottomScreens> {
  int currentIndex = 0;
  final screens = [
    const HomeScreen(),
    const SearchBar(),
    const FavoriteScreen(),
    const PlayListSc(),
  ];
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 156, 0, 78),
          Color.fromARGB(255, 0, 0, 0)
        ], stops: [
          0.5,
          1
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(index: currentIndex, children: screens),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: FavoriteDB.favoriteSongs,
          builder:
              (BuildContext context, List<SongModel> music, Widget? child) {
            return SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (GetSongs.player.currentIndex != null)
                  Column(
                    children: const [
                      GlassMorphism(
                          start: 0.1, end: 0.5, radius: 0, child: MiniPlayer()),
                      SizedBox(height: 10),
                    ],
                  )
                else
                  const SizedBox(),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                  child: GlassMorphism(
                    start: 0.1,
                    end: 0.5,
                    child: GlassMorphism(
                      start: 0.1,
                      end: 0.5,
                      child: BottomNavigationBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        selectedItemColor: Colors.black,
                        selectedFontSize: 15,
                        unselectedItemColor: Color.fromRGBO(0, 0, 0, 0.38),
                        selectedIconTheme: const IconThemeData(
                            color: Color.fromARGB(255, 235, 0, 0)),
                        showUnselectedLabels: false,
                        type: BottomNavigationBarType.fixed,
                        currentIndex: currentIndex,
                        onTap: (index) {
                          setState(() {
                            currentIndex = index;
                            FavoriteDB.favoriteSongs.notifyListeners();
                          });
                        },
                        items: const [
                          BottomNavigationBarItem(
                              icon: Icon(Icons.music_note), label: 'All songs'),
                          BottomNavigationBarItem(
                              icon: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Icon(Icons.search),
                              ),
                              label: 'Search'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.favorite_border),
                              label: 'Favorites'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.queue_music_sharp),
                              label: 'Playlist'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ));
          },
        ),
      ),
    );
  }
}
