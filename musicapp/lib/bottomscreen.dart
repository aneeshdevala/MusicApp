import 'package:flutter/material.dart';
import 'package:musicapp/favorite.dart';
import 'package:musicapp/playlist.dart';
import 'package:musicapp/search.dart';

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
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.black,
        selectedFontSize: 15,
        unselectedItemColor: Colors.black38,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note), label: 'All songs'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.queue_music_sharp), label: 'Playlist'),
        ],
      ),
    );
  }
}
