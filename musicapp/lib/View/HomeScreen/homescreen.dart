import 'package:flutter/material.dart';
import 'package:musicapp/Controller/DbProviders/favdatabase_provider.dart';
import 'package:musicapp/Controller/Providers/home_provider.dart';

import 'package:musicapp/Controller/Providers/favoritebuttonlogic.dart';

import 'package:musicapp/View/HomeScreen/Widgets/home_appbar.dart';
import 'package:musicapp/View/Settings/settings.dart';
import 'package:musicapp/Controller/Widgets/getsongstorage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../Controller/Widgets/glass.dart';
import '../NowPlay/nowplaying.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  static List<SongModel> song = [];

  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HomeProvider>(context, listen: false).requestPermission();
    });
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.0),
            bottom: Radius.circular(30.0),
          ),
          child: GlassMorphism(
            start: 0.1,
            end: 0.5,
            child: SizedBox(
              height: 380,
              width: 200,
              child: SettingsDrawer(),
            ),
          ),
        ),
        appBar: const PreferredSize(
            preferredSize: Size(double.maxFinite, 60), child: HomeAppBar()),
        body: Consumer<HomeProvider>(
          builder: ((context, value, child) => FutureBuilder<List<SongModel>>(
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
                  if (!Provider.of<FavoriteDB>(context, listen: false)
                      .isInitialized) {
                    // if (!FavoriteDB.isInitialized) {
                    Provider.of<FavoriteDB>(context, listen: false)
                        .initialise(item.data!);
                  }

                  GetSongs.songscopy = item.data!;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                              Provider.of<HomeProvider>(context, listen: false)
                                  .notifyListeners();
                              //setState(() {});

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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                                        artworkBorder: const BorderRadius.all(
                                            Radius.circular(5)),
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
                                                    item.data![index]
                                                        .displayNameWOExt,
                                                    style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    "${item.data![index].album}",
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: FavoriteBut(
                                                song: HomeScreen.song[index]),
                                          )
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
              )),
        ));
  }
}
