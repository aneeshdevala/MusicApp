import 'package:flutter/material.dart';

import 'package:musicapp/Database/favoritebtn.dart';
import 'package:musicapp/Database/favoritedb.dart';
import 'package:musicapp/Database/playlsitsongdb.dart';

import 'package:musicapp/getsongstorage.dart';
import 'package:musicapp/widgets/glass.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'SettingsScreen/sharefile.dart';

import 'childscreen/nowplaying.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static List<SongModel> song = [];

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  // final AudioPlayer _audioPlayer = AudioPlayer();

  // playSong(String? uri) {
  //   try {
  //     //song might be currepted so using exception
  //     _audioPlayer.setAudioSource(
  //       AudioSource.uri(
  //         Uri.parse(uri!),
  //       ),
  //     );
  //     _audioPlayer.play();
  //   } on Exception {
  //     log("Error parsing song");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    await Permission.storage.request();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    return Scaffold(
      backgroundColor: Colors.transparent,
      endDrawer: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30.0),
          bottom: Radius.circular(30.0),
        ),
        child: GlassMorphism(
          start: 0.1,
          end: 0.5,
          child: SizedBox(
            height: 380,
            width: 200,
            child: Drawer(
              child: Container(
                //  color: Colors.transparent,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 156, 0, 78),
                  Color.fromARGB(255, 0, 0, 0)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      leading: const Icon(Icons.message_outlined),
                      title: const Text(
                        'Feedback',
                      ),
                      onTap: () {
                        _email();
                      },
                    ),
                    ListTile(
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      leading: const Icon(Icons.share_outlined),
                      title: const Text('Share this App'),
                      onTap: () {
                        shareFile(context);
                      },
                    ),
                    const ListTile(
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      leading: Icon(Icons.lock),
                      title: Text('Privacy Policy'),
                      // onTap#5558da: () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const PrivacyPol()));
                      // },
                    ),
                    ListTile(
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      leading: const Icon(Icons.star_border_outlined),
                      title: const Text('Rate this App'),
                      onTap: () {
                        _ratingApp();
                      },
                    ),
                    ListTile(
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      leading: const Icon(Icons.restore),
                      title: const Text('Reset App'),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Reset App'),
                                content: const Text(
                                    'Are you sure you want to reset the app?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Reset'),
                                    onPressed: () {
                                      appReset(context);
                                    },
                                  ),
                                ],
                              );
                            });
                        // appReset(context);
                      },
                    ),
                    ListTile(
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      leading: const Icon(Icons.info_outlined),
                      title: const Text('About Developer'),
                      onTap: () {
                        _aboutdeveloper();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'v.1.0.0',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: RichText(
          text: TextSpan(
            text: 'm u s i c ',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.grey[350]),
            children: const <TextSpan>[
              TextSpan(
                  text: 'A',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                      color: Colors.green)),
            ],
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return const Center(
              child: Text('Sorry No Songs Found'),
            );
          }
          HomeScreen.song = item.data!;
          if (!FavoriteDB.isInitialized) {
            FavoriteDB.initialise(item.data!);
          }

          GetSongs.songscopy = item.data!;
          //GetSongs.playingSongs = item.data!;

          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return GlassMorphism(
                  start: 0.1,
                  end: 0.5,
                  child: GestureDetector(
                    onTap: () {
                      GetSongs.player.setAudioSource(
                          GetSongs.createSongList(item.data!),
                          initialIndex: index);
                      GetSongs.player.play();
                      setState(() {});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NowPlay(
                              playerSong: item.data!,
                            ), //songmodel Passing
                          ));
                      //   FavoriteDB.favoriteSongs.notifyListeners();
                    },
                    child: GlassMorphism(
                      start: 0.0,
                      end: 0.0,
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              //  flex: 6,
                              child: QueryArtworkWidget(
                                id: item.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note_outlined,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                artworkFit: BoxFit.fill,
                                artworkBorder:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      // ignore: sized_box_for_whitespace
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.data![index].displayNameWOExt,
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "${item.data![index].album}",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: FavoriteBut(
                                          song: HomeScreen.song[index]))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _email() async {
    // ignore: deprecated_member_use
    if (await launch('mailto:aneesh172.ant@gmail.com')) {
      throw "Try Again";
    }
  }

  Future<void> _aboutdeveloper() async {
    // ignore: deprecated_member_use
    if (await launch(
        'https://aneeshdevala.github.io/Protfolio-Personalwebsite/')) {
      throw "Try Again";
    }
  }

  Future<void> _ratingApp() async {
    // ignore: deprecated_member_use
    if (await launch(
        'https://play.google.com/store/apps/details?id=in.brototype.music_app')) {
      throw "Try Again";
    }
  }
}
