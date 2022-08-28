import 'package:flutter/material.dart';
import 'package:musicapp/Controller/Widgets/getsongstorage.dart';

class MiniPlayerPro extends ChangeNotifier {
  void mountedfun() async {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null) {
        notifyListeners();
      }
    });
  }
}
