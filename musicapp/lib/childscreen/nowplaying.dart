import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:musicapp/Database/favoritedb.dart';

import 'package:musicapp/getsongstorage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

import '../Database/favoritebtn.dart';

class NowPlay extends StatefulWidget {
  const NowPlay({
    Key? key,
    required this.playerSong,
  }) : super(key: key);

  final List<SongModel> playerSong;
  @override
  State<NowPlay> createState() => _NowPlayState();
}

class _NowPlayState extends State<NowPlay> {
  bool _isPlaying = true;
  int currentIndex = 0;

  @override
  void initState() {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          currentIndex = index;
        });
        GetSongs.currentIndes = index;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 214, 201, 18),
          Color.fromARGB(255, 233, 211, 211)
        ], stops: [
          0.5,
          1
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.8),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                        FavoriteDB.favoriteSongs.notifyListeners();
                      },
                      icon: const Icon(Icons.keyboard_arrow_down_rounded)),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 400,
                          width: 300,
                          child: QueryArtworkWidget(
                            keepOldArtwork: true,
                            id: widget.playerSong[currentIndex].id,
                            quality: 100,
                            type: ArtworkType.AUDIO,
                            artworkFit: BoxFit.fill,
                            artworkBorder: BorderRadius.circular(50),
                            nullArtworkWidget: Lottie.asset(
                              // 'assets/undraw_Compose_music_re_wpiw-removebg-preview.png',
                              'assets/mini.json',
                            )

                            //  const Icon(
                            //   Icons.music_note_outlined,
                            //   size: 200,
                            // ),
                            ,
                            artworkWidth: 300,
                            artworkHeight: 400,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  Text(
                                    widget.playerSong[currentIndex]
                                        .displayNameWOExt,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    widget.playerSong[currentIndex].artist
                                                .toString() ==
                                            "<unknown>"
                                        ? "Unknown Artist"
                                        : widget.playerSong[currentIndex].artist
                                            .toString(),
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FavoriteBut(song: widget.playerSong[currentIndex])
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StreamBuilder<DurationState>(
                            stream: _durationStateStream,
                            builder: (context, snapshot) {
                              final durationState = snapshot.data;
                              final progress =
                                  durationState?.position ?? Duration.zero;
                              final total =
                                  durationState?.total ?? Duration.zero;
                              return ProgressBar(
                                  progress: progress,
                                  total: total,
                                  barHeight: 3.0,
                                  thumbRadius: 5,
                                  progressBarColor: Colors.white,
                                  thumbColor: Colors.white,
                                  baseBarColor: Colors.grey,
                                  bufferedBarColor: Colors.grey,
                                  buffered: const Duration(milliseconds: 2000),
                                  onSeek: (duration) {
                                    GetSongs.player.seek(duration);
                                  });
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: const EdgeInsets.all(15),
                                    primary: Colors.transparent,
                                    onPrimary: Colors.black),
                                onPressed: () {
                                  GetSongs.player.setShuffleModeEnabled(true);
                                  GetSongs.player.setShuffleModeEnabled(false);
                                  const ScaffoldMessenger(
                                      child: SnackBar(
                                          content: Text('Shuffle Enabled')));
                                },
                                child: StreamBuilder<bool>(
                                    stream: GetSongs
                                        .player.shuffleModeEnabledStream,
                                    builder: (context, snapshot) {
                                      bool? shuffleState = snapshot.data;
                                      if (shuffleState != null &&
                                          shuffleState) {
                                        return const Icon(
                                          Icons.shuffle,
                                          color: Colors.white,
                                          size: 25,
                                        );
                                      } else {
                                        return const Icon(
                                          Icons.shuffle,
                                          size: 25,
                                          color: Colors.black,
                                        );
                                      }
                                    }),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  if (GetSongs.player.hasPrevious) {
                                    await GetSongs.player.seekToPrevious();
                                    await GetSongs.player.play();
                                  } else {
                                    await GetSongs.player.play();
                                  }
                                },
                                icon: const Icon(
                                  Icons.skip_previous,
                                  size: 50,
                                )),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (_isPlaying) {
                                      GetSongs.player.pause();
                                    } else {
                                      GetSongs.player.play();
                                    }
                                    _isPlaying = !_isPlaying;
                                  });
                                },
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 50,
                                )),
                            IconButton(
                                onPressed: (() async {
                                  if (GetSongs.player.hasNext) {
                                    await GetSongs.player.seekToNext();
                                    await GetSongs.player.play();
                                  } else {
                                    await GetSongs.player.play();
                                  }
                                }),
                                icon: const Icon(
                                  Icons.skip_next,
                                  size: 50,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Colors.transparent,
                                      onPrimary: Colors.black),
                                  onPressed: () {
                                    GetSongs.player.loopMode == LoopMode.one
                                        ? GetSongs.player
                                            .setLoopMode(LoopMode.all)
                                        : GetSongs.player
                                            .setLoopMode(LoopMode.one);
                                  },
                                  child: StreamBuilder<LoopMode>(
                                    stream: GetSongs.player.loopModeStream,
                                    builder: (context, snapshot) {
                                      final loopMode = snapshot.data;
                                      if (LoopMode.one == loopMode) {
                                        return const Icon(
                                          Icons.repeat_one,
                                          color: Colors.white,
                                          size: 25,
                                        );
                                      } else {
                                        return const Icon(
                                          Icons.repeat,
                                          size: 30,
                                        );
                                      }
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        )),
      ),
    );
    // });
  }

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          GetSongs.player.positionStream,
          GetSongs.player.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
