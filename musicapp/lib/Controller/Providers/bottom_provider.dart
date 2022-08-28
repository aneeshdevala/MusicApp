import 'package:flutter/widgets.dart';

class BottomProvider extends ChangeNotifier {
  int _currentIndex = 0;
  get currentIndex => _currentIndex;
  set currentIndex(index) {
    _currentIndex = index;
    notifyListeners();
  }
}
