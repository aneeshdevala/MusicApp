import 'package:flutter/material.dart';
import 'package:musicapp/Controller/DbProviders/playlsitsongdb_prov.dart';
import 'package:musicapp/Model/musicplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SongListPage extends StatelessWidget {
  SongListPage({Key? key, required this.playlist}) : super(key: key);

  final MusicPlayer playlist;

  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlayListDb>(
      context,
    );
    return Consumer<PlayListDb>(
        builder: ((context, value, child) => Container(
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
                                    fontSize: 25,
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
                                  provider;
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
                                      iconColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      textColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      leading: QueryArtworkWidget(
                                        id: item.data![index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: const Icon(
                                            Icons.music_note_outlined),
                                        artworkFit: BoxFit.fill,
                                        artworkBorder: const BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      title: Text(
                                        item.data![index].displayNameWOExt,
                                        maxLines: 1,
                                      ),
                                      subtitle: Text(
                                        "${item.data![index].artist}",
                                        maxLines: 1,
                                      ),
                                      trailing: Consumer<PlayListDb>(
                                        builder: (context, value, child) =>
                                            IconButton(
                                                onPressed: () {
                                                  playlistCheck(
                                                      item.data![index],
                                                      context);
                                                  provider;
                                                },
                                                icon: playlist.isValueIn(
                                                        item.data![index].id)
                                                    ? const Icon(Icons
                                                        .check_circle_outline)
                                                    : const Icon(Icons
                                                        .remove_circle_outline),
                                                color: playlist.isValueIn(
                                                        item.data![index].id)
                                                    ? Colors.green
                                                    : Colors.red),
                                      ),
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
                )))));
  }

  void playlistCheck(SongModel data, context) {
    if (!playlist.isValueIn(data.id)) {
      playlist.add(data.id);
      const snackbar = SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Added to Playlist',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(milliseconds: 250));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      playlist.deleteData(data.id);
      const snackbar = SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Removed from Playlist',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(milliseconds: 250));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
