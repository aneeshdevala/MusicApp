import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:musicapp/Database/playlsitsongdb.dart';
import 'package:musicapp/childscreen/playlistsongs.dart';
import 'package:musicapp/model/musicplayer.dart';
import 'package:musicapp/widgets/glass.dart';

class PlayListSc extends StatefulWidget {
  const PlayListSc({Key? key}) : super(key: key);

  @override
  State<PlayListSc> createState() => _PlayListScState();
}

final nameController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _PlayListScState extends State<PlayListSc> {
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return ValueListenableBuilder(
        valueListenable: Hive.box<MusicPlayer>('playlistDB').listenable(),
        builder:
            (BuildContext context, Box<MusicPlayer> musicList, Widget? child) {
          return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title: const Text(
                      'P l a y L i s t ',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    //centerTitle: true,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SafeArea(
                      child: Hive.box<MusicPlayer>('playlistDB').isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/playlist.svg",
                                    height: 300,
                                    width: 200,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Add your Playlist      ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  ),

                                  // Lottie.asset(
                                  //   'assets/fav.json',
                                  //   height: 200,
                                  //   width: 200,
                                  // ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 5,
                              ),
                              itemCount: musicList.length,
                              itemBuilder: (context, index) {
                                final data = musicList.values.toList()[index];
                                return ValueListenableBuilder(
                                    valueListenable:
                                        Hive.box<MusicPlayer>('playlistDB')
                                            .listenable(),
                                    builder: (BuildContext context,
                                        Box<MusicPlayer> musicList,
                                        Widget? child) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return PlaylistData(
                                              playlist: data,
                                              folderindex: index,
                                            );
                                          }));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: GlassMorphism(
                                            end: 0.5,
                                            start: 0.1,
                                            child: Card(
                                              color: Colors.transparent,
                                              elevation: 0,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Expanded(
                                                    child:
                                                        //     QueryArtworkWidget(
                                                        //   id: PlaylistData
                                                        //       .playlistSongid[
                                                        //           index]
                                                        //       .id,
                                                        //   type:
                                                        //       ArtworkType.AUDIO,
                                                        //   nullArtworkWidget:
                                                        //       const Icon(
                                                        //     Icons.music_note,
                                                        //   ),
                                                        //   errorBuilder:
                                                        //       (context,
                                                        //           excepion,
                                                        //           gdb) {
                                                        //     setState(() {});
                                                        //     return Image.asset(
                                                        //         '');
                                                        //   },
                                                        // ),
                                                        Image.asset(
                                                      'assets/undraw_Compose_music_re_wpiw-removebg-preview.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  // const SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 8,
                                                      right: 8,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 4,
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            // ignore: sized_box_for_whitespace
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  data.name,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white60,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 1,
                                                            child: IconButton(
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .delete_outlined,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                ),
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('Delete Playlist'),
                                                                          content:
                                                                              const Text('Are you sure you want to delete this playlist?'),
                                                                          actions: <
                                                                              Widget>[
                                                                            TextButton(
                                                                              child: const Text('No'),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                            TextButton(
                                                                              child: const Text('Yes'),
                                                                              onPressed: () {
                                                                                musicList.deleteAt(index);
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      });
                                                                }))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    splashColor: Colors.red[900],
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // playlistnotifier.notifyListeners();

                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: SizedBox(
                                height: 250,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Center(
                                        child: Text(
                                          'Create Your Playlist',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: TextFormField(
                                            controller: nameController,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: ' Playlist Name'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please enter playlist name";
                                              } else {
                                                return null;
                                              }
                                            }),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                              width: 100.0,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: const Color
                                                                  .fromARGB(255,
                                                              255, 255, 255)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                  ))),
                                          SizedBox(
                                              width: 100.0,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: const Color
                                                                  .fromARGB(
                                                              255, 139, 0, 81)),
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      whenButtonClicked();
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Save',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: const Icon(Icons.add),
                  )));
        });
  }

  Future<void> whenButtonClicked() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      final music = MusicPlayer(
        songIds: [],
        name: name,
      );
      playlistAdd(music);
      nameController.clear();
    }
  }
}
