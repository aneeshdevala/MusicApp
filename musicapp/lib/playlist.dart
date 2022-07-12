import 'package:flutter/material.dart';
import 'package:musicapp/Database/Playlsitsongdb.dart';
import 'package:musicapp/Database/playlistfoldb.dart';
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
    getAllPlaylist();
    PlayList.folderPlayList.notifyListeners;
    return ValueListenableBuilder(
        valueListenable: playlistnotifier,
        builder:
            (BuildContext context, List<MusicPlayer> musicList, Widget? child) {
          return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFFDD4C4C),
                  Color.fromARGB(255, 255, 255, 255)
                ], stops: [
                  0.5,
                  1
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title: const Text(
                      'Playlist',
                      style: TextStyle(color: Colors.black),
                    ),
                    centerTitle: true,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(30),
                    child: SafeArea(
                      child: Column(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: playlistnotifier,
                            builder: (BuildContext context,
                                List<MusicPlayer> musicList, Widget? child) {
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  final data = musicList[index];
                                  return ListTile(
                                    leading: const Icon(Icons.music_note),
                                    title: Text(data.name),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_outlined),
                                      onPressed: () {
                                        playlistDelete(index);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    // onTap: () {
                                    //   Navigator.of(context)
                                    //       .push(MaterialPageRoute(builder: (context) {
                                    //     return PlayListSc(
                                    //       folderindex: index,
                                    //       musicPlayer: data,
                                    //     );
                                    //   }));
                                    // },
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
                    ),
                  ),
                  floatingActionButton: SizedBox(
                    height: 50,
                    //width: 60,
                    child: FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctxt) => creatPlaylist());
                      },
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ));
        });
  }

  Widget creatPlaylist() {
    playlistnotifier.notifyListeners();
    return AlertDialog(
      title: const Text('Playlist Name'),
      content: TextFormField(
        decoration: const InputDecoration(hintText: 'Name required'),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              whenButtonClicked();
              Navigator.of(context).pop();
            },
            child: const Text('Save')),
      ],
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 227, 220, 220),
    );
  }

  Future<void> whenButtonClicked() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      final music = MusicPlayer(name: name);
      playlistAdd(music);
    }
  }
}
