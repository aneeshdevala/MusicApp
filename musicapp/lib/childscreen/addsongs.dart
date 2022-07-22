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
          gradient: LinearGradient(
              colors: [Color(0xFFDD4C4C), Color.fromARGB(255, 233, 211, 211)],
              stops: [0.5, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
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
                                color: Color.fromARGB(255, 0, 0, 0)),
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
                              color: Color.fromARGB(255, 0, 0, 0),
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
                                    color: Color.fromARGB(255, 0, 0, 0)),
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
                                  iconColor: const Color.fromARGB(255, 0, 0, 0),
                                  textColor: const Color.fromARGB(255, 0, 0, 0),
                                  leading: QueryArtworkWidget(
                                    id: item.data![index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget:
                                        const Icon(Icons.music_note_outlined),
                                    artworkFit: BoxFit.fill,
                                    artworkBorder: const BorderRadius.all(
                                        Radius.circular(30)),
                                  ),
                                  title:
                                      Text(item.data![index].displayNameWOExt),
                                  subtitle: Text("${item.data![index].artist}"),
                                  trailing: IconButton(
                                      onPressed: () {
                                        playlistCheck(item.data![index]);
                                        //     playlistnotifier.notifyListeners();
                                      },
                                      icon: const Icon(Icons.add)),
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
    }
  }
}
