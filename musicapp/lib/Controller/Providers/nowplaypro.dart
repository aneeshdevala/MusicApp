import 'package:flutter/material.dart';
import 'package:musicapp/Controller/Widgets/getsongstorage.dart';

class NowPlayPro extends ChangeNotifier {
  int currentIndex = 0;
  mountedfun() {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null) {
        notifyListeners();
        currentIndex = index;
        GetSongs.currentIndes = index;
      }
      notifyListeners();
    });
  }
}
