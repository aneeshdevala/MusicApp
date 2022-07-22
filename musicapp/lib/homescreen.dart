import 'package:flutter/material.dart';

import 'package:musicapp/Database/favoritebtn.dart';
import 'package:musicapp/Database/favoritedb.dart';
import 'package:musicapp/Database/playlsitsongdb.dart';
import 'package:musicapp/SettingsScreen/privacpolicy.dart';
import 'package:musicapp/getsongstorage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'SettingsScreen/feedback.dart';
import 'SettingsScreen/sharefile.dart';
import 'SettingsScreen/terms.dart';
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

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 209, 3, 175),
          Color.fromARGB(255, 39, 32, 32)
        ], stops: [
          0.5,
          1
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30.0),
            bottom: Radius.circular(30.0),
          ),
          child: SizedBox(
            height: 380,
            width: 200,
            child: Drawer(
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 4, 255, 129),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                )),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.message_outlined),
                      title: const Text('Feedback'),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const FeedBack();
                        }));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.share_outlined),
                      title: const Text('Share this App'),
                      onTap: () {
                        shareFile(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Privacy Policy'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PrivacyPol()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.star_border_outlined),
                      title: const Text('Rate this App'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
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
                      leading: const Icon(Icons.info_outlined),
                      title: const Text('About'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Terms()));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'version [1.0.0]',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'MusiFy',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.settings_outlined),
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

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 5,
              ),
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
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
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                      ),
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
                              ),
                              artworkFit: BoxFit.fill,
                              artworkBorder:
                                  const BorderRadius.all(Radius.circular(30)),
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
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "${item.data![index].album}",
                                          style: const TextStyle(fontSize: 10),
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
