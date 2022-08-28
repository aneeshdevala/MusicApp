import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:musicapp/Controller/DbProviders/favdatabase_provider.dart';
import 'package:musicapp/View/NowPlay/nowplaying.dart';
import 'package:musicapp/Controller/Widgets/getsongstorage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final provider = Provider.of<FavoriteDB>(context);

    return Consumer<FavoriteDB>(builder: (context, value, child) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'F a v o r i t e s ',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            //centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: value.favoriteSongs.isEmpty
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/fav.json',
                        height: 200,
                        width: 200,
                      ),
                      const Text(
                        'No favorites yet',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ))
                : ListView(children: [
                    Consumer<FavoriteDB>(
                      builder: (context, value, child) {
                        return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, index) {
                              return ListTile(
                                onTap: () {
                                  // FavoriteDB.favoriteSongs
                                  //     .notifyListeners();
                                  List<SongModel> newlist = [
                                    ...value.favoriteSongs
                                  ];
                                  provider;
                                  GetSongs.player.stop();
                                  GetSongs.player.setAudioSource(
                                      GetSongs.createSongList(newlist),
                                      initialIndex: index);
                                  GetSongs.player.play();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => NowPlay(
                                            playerSong: newlist,
                                          )));
                                },
                                leading: QueryArtworkWidget(
                                  id: value.favoriteSongs[index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Icon(
                                    Icons.music_note_outlined,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                title: Text(
                                  value.favoriteSongs[index].title,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 15),
                                ),
                                subtitle: Text(
                                  value.favoriteSongs[index].album!,
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      // FavoriteDB.favoriteSongs.value
                                      //     .removeAt(index);
                                      provider;
                                      value.delete(
                                          value.favoriteSongs[index].id);
                                      //  setState(() {});
                                      const snackbar = SnackBar(
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255),
                                          content: Text(
                                            'Song deleted from favorite',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          duration:
                                              Duration(microseconds: 190));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                    },
                                    icon: const Icon(
                                      Icons.heart_broken_sharp,
                                      color: Colors.white,
                                      size: 30,
                                    )),
                              );
                            },
                            separatorBuilder: (ctx, index) {
                              return const Divider();
                            },
                            itemCount: value.favoriteSongs.length);
                      },
                    ),
                  ]),
          ),
        ),
      );
    });
  }
}
