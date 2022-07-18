import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicapp/Database/playlsitsongdb.dart';
import 'package:musicapp/childscreen/playlistsongs.dart';
import 'package:musicapp/model/musicplayer.dart';

class PlayListSc extends StatefulWidget {
  const PlayListSc({Key? key}) : super(key: key);

  // final MusicPlayer musicPlayer;
  // final int? folderindex;

  @override
  State<PlayListSc> createState() => _PlayListScState();
}

final nameController = TextEditingController();

class _PlayListScState extends State<PlayListSc> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFDD4C4C), Color.fromARGB(255, 255, 255, 255)],
              stops: [0.5, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Text(
                'Playlist',
                style: TextStyle(color: Colors.black),
              ),
              //centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SafeArea(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        ValueListenableBuilder(
                          valueListenable:
                              Hive.box<MusicPlayer>('playlistDB').listenable(),
                          builder: (BuildContext context,
                              Box<MusicPlayer> musicList, Widget? child) {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final data = musicList.values.toList()[index];
                                return ListTile(
                                  leading: const Icon(Icons.music_note),
                                  title: Text(data.name),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outlined),
                                    onPressed: () {
                                      playlistDelete(index);
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return PlaylistData(
                                        playlist: data,
                                        folderindex: index,
                                      );
                                    }));
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: musicList.length,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
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
                                TextFormField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: ' Playlist Name'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Value is Empty";
                                      } else {
                                        return null;
                                      }
                                    }),
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
                                                    255, 194, 67, 9)),
                                            onPressed: () {
                                              whenButtonClicked();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Save'))),
                                    SizedBox(
                                        width: 100.0,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: const Color.fromARGB(
                                                    255, 194, 67, 9)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel')))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.add),
            ),
          ),
        ));
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
