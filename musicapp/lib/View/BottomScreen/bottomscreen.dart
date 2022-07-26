import 'package:flutter/material.dart';

import 'package:musicapp/Controller/Providers/bottom_provider.dart';
import 'package:musicapp/Controller/Widgets/glass.dart';
import 'package:musicapp/View/MiniPlayer/miniscreen.dart';
import 'package:musicapp/View/Favorites/favorite.dart';
import 'package:musicapp/View/PlayList/playlist_folders.dart';
import 'package:musicapp/View/Search/search_screen.dart';

import 'package:provider/provider.dart';

import '../../Controller/Widgets/getsongstorage.dart';
import '../HomeScreen/homescreen.dart';

class BottomScreens extends StatelessWidget {
  BottomScreens({Key? key}) : super(key: key);

  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    const SearchBar(),
    const FavoriteScreen(),
    PlayListSc(),
  ];
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomProvider>(context);
    //FocusManager.instance.primaryFocus?.unfocus();
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
        bottomNavigationBar: Consumer<BottomProvider>(
          builder: (context, value, child) {
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
                        unselectedItemColor:
                            const Color.fromRGBO(0, 0, 0, 0.38),
                        selectedIconTheme: const IconThemeData(
                            color: Color.fromARGB(255, 235, 0, 0)),
                        showUnselectedLabels: false,
                        type: BottomNavigationBarType.fixed,
                        currentIndex: currentIndex,
                        onTap: (index) {
                          currentIndex = index;
                          provider.currentIndex = index;
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
