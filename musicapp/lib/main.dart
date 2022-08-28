import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicapp/Controller/DbProviders/favdatabase_provider.dart';
import 'package:musicapp/Controller/Providers/bottom_provider.dart';
import 'package:musicapp/Controller/Providers/home_provider.dart';
import 'package:musicapp/Controller/DbProviders/playlsitsongdb_prov.dart';
import 'package:musicapp/Controller/Providers/miniplayer.dart';
import 'package:musicapp/Controller/Providers/nowplaypro.dart';
import 'package:musicapp/Controller/Providers/search_provider.dart';
import 'package:musicapp/Model/musicplayer.dart';

import 'package:musicapp/View/SplashScreen/splashscreen.dart';
import 'package:provider/provider.dart';

//import 'package:musicapp/homescreen.dart';
//import 'package:musicapp/splashscreen.dart';
Future<void> main() async {
  //set database initialise
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicPlayerAdapter().typeId)) {
    //adapter registered
    Hive.registerAdapter(MusicPlayerAdapter());
  }
  await Hive.openBox<int>('favoriteDB');
  await Hive.openBox<MusicPlayer>('playlistDB');

  await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      preloadArtwork: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteDB()),
        ChangeNotifierProvider(create: (context) => PlayListDb()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => BottomProvider()),
        ChangeNotifierProvider(create: (context) => MiniPlayerPro()),
        ChangeNotifierProvider(create: (context) => NowPlayPro()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.grey),
        home: const SplashScreen(),
      ),
    );
  }
}
