import 'package:flutter/widgets.dart';
import 'package:musicapp/View/HomeScreen/homescreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchProvider extends ChangeNotifier {
  List<SongModel> temp = [];
  searchFilter(value) {
    if (value != null && value.isNotEmpty) {
      temp.clear();
      for (SongModel item in HomeScreen.song) {
        if (item.title.toLowerCase().contains(value.toLowerCase())) {
          temp.add(item);
        }
      }
    }
    notifyListeners();
  }
}
