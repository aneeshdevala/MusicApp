import 'package:flutter/material.dart';

import 'package:musicapp/model/musicplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({Key? key, required this.playlist}) : super(key: key);

  final MusicPlayer playlist;
  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    // playlistnotifier.notifyListeners();
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 156, 0, 78),
            Color.fromARGB(255, 0, 0, 0)
          ], stops: [
            0.5,
            1
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SafeArea(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Center(
                          child: Text(
                            'Add Songs ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                        const SizedBox(
                          width: 190,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 20,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    FutureBuilder<List<SongModel>>(
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
                              child: Text(
                                'NO Songs Found',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            );
                          }
                          return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (ctx, index) {
                                return ListTile(
                                  onTap: () {},
                                  iconColor: Color.fromARGB(255, 255, 255, 255),
                                  textColor: Color.fromARGB(255, 255, 255, 255),
                                  leading: QueryArtworkWidget(
                                    id: item.data![index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget:
                                        const Icon(Icons.music_note_outlined),
                                    artworkFit: BoxFit.fill,
                                    artworkBorder: const BorderRadius.all(
                                        Radius.circular(30)),
                                  ),
                                  title: Text(
                                    item.data![index].displayNameWOExt,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    "${item.data![index].artist}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          playlistCheck(item.data![index]);
                                        });

                                        //     playlistnotifier.notifyListeners();
                                      },
                                      icon: !widget.playlist
                                              .isValueIn(item.data![index].id)
                                          ? const Icon(Icons.add_task_rounded)
                                          : const Icon(Icons.close_rounded),
                                      color: !widget.playlist
                                              .isValueIn(item.data![index].id)
                                          ? Colors.white
                                          : Colors.red),
                                );
                              },
                              separatorBuilder: (ctx, index) {
                                return const Divider();
                              },
                              itemCount: item.data!.length);
                        })
                  ]),
                ),
              ),
            )));
  }

  void playlistCheck(SongModel data) {
    if (!widget.playlist.isValueIn(data.id)) {
      widget.playlist.add(data.id);
      const snackbar = SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Added to Playlist',
            style: TextStyle(color: Colors.white),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      widget.playlist.deleteData(data.id);
      const snackbar = SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Song deleted from Playlist',
            style: TextStyle(color: Colors.white),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
