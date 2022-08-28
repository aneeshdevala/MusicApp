import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:musicapp/Controller/DbProviders/playlsitsongdb_prov.dart';
import 'package:musicapp/View/PlayList/playlist_songs.dart';
import 'package:musicapp/Model/musicplayer.dart';

import 'package:provider/provider.dart';

import '../../Controller/Widgets/glass.dart';

class PlayListSc extends StatelessWidget {
  PlayListSc({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlayListDb>(context, listen: false).getAllPlaylist();
    });
    FocusManager.instance.primaryFocus?.unfocus();
    return Consumer<PlayListDb>(builder: (context, value, child) {
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
                          itemCount: value.playlistnotifier.length,
                          itemBuilder: (context, index) {
                            final data = value.playlistnotifier.toList()[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
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
                                          child: Image.asset(
                                            'assets/undraw_Compose_music_re_wpiw-removebg-preview.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
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
                                                            color:
                                                                Colors.white60,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: IconButton(
                                                      icon: const Icon(
                                                        Icons.delete_outlined,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Delete Playlist'),
                                                                content: const Text(
                                                                    'Are you sure you want to delete this playlist?'),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    child:
                                                                        const Text(
                                                                            'No'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: const Text(
                                                                        'Yes'),
                                                                    onPressed:
                                                                        () {
                                                                      value.playlistDelete(
                                                                          index);
                                                                      Navigator.pop(
                                                                          context);
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          if (value == null || value.isEmpty) {
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
                                              style: ElevatedButton.styleFrom(
                                                  primary: const Color.fromARGB(
                                                      255, 255, 255, 255)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Cancel',
                                              ))),
                                      SizedBox(
                                          width: 100.0,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: const Color.fromARGB(
                                                      255, 139, 0, 81)),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  whenButtonClicked(context);
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

  Future<void> whenButtonClicked(context) async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      final music = MusicPlayer(
        songIds: [],
        name: name,
      );
      Provider.of<PlayListDb>(context, listen: false).playlistAdd(music);

      // playlistAdd(music);
      nameController.clear();
    }
  }
}
