import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicapp/model/musicplayer.dart';

import 'package:musicapp/splashscreen.dart';

//import 'package:musicapp/homescreen.dart';
//import 'package:musicapp/splashscreen.dart';
Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  //setu[ database initialise
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<int>('favoriteDB');
  await Hive.openBox<int>('playlistDB');
  if (!Hive.isAdapterRegistered(MusicPlayerAdapter().typeId)) {
    //adapter registered
    Hive.registerAdapter(MusicPlayerAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: SplashScreen(),
    );
  }
}
