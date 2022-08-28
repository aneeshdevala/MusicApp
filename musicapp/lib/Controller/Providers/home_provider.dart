import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeProvider extends ChangeNotifier {
  void requestPermission() async {
    await Permission.storage.request();
    notifyListeners();
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
