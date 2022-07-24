import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:musicapp/Database/favoritedb.dart';

import 'package:musicapp/getsongstorage.dart';
import 'package:musicapp/widgets/textanimation.dart';
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
          Color.fromARGB(255, 156, 0, 78),
          Color.fromARGB(255, 0, 0, 0)
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
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    color: Colors.white,
                    iconSize: 40,
                  ),
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
                                  AnimatedText(
                                    text: widget.playerSong[currentIndex]
                                        .displayNameWOExt,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          widget.playerSong[currentIndex].artist
                                                      .toString() ==
                                                  "<unknown>"
                                              ? "Unknown Artist"
                                              : widget.playerSong[currentIndex]
                                                  .artist
                                                  .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.volume_up),
                                          color: Colors.white,
                                          onPressed: () {
                                            showSliderDialog(
                                              context: context,
                                              title: "Adjust volume",
                                              divisions: 10,
                                              min: 0.0,
                                              max: 1.0,
                                              value: GetSongs.player.volume,
                                              stream:
                                                  GetSongs.player.volumeStream,
                                              onChanged:
                                                  GetSongs.player.setVolume,
                                            );
                                          },
                                        ),
                                        StreamBuilder<double>(
                                          stream: GetSongs.player.speedStream,
                                          builder: (context, snapshot) =>
                                              IconButton(
                                            icon: Text(
                                                "${snapshot.data?.toStringAsFixed(1)}x",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            onPressed: () {
                                              showSliderDialog(
                                                context: context,
                                                title: "Adjust speed",
                                                divisions: 10,
                                                min: 0.5,
                                                max: 1.5,
                                                value: GetSongs.player.speed,
                                                stream:
                                                    GetSongs.player.speedStream,
                                                onChanged:
                                                    GetSongs.player.setSpeed,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
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
                                          size: 35,
                                        );
                                      } else {
                                        return const Icon(
                                          Icons.shuffle,
                                          size: 35,
                                          color: Colors.white,
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
                                  color: Colors.white,
                                  size: 50,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    primary: Colors.black,
                                    onPrimary: Colors.green),
                                onPressed: () async {
                                  if (GetSongs.player.playing) {
                                    await GetSongs.player.pause();
                                    setState(() {});
                                  } else {
                                    await GetSongs.player.play();
                                    setState(() {});
                                  }
                                },
                                child: StreamBuilder<bool>(
                                  stream: GetSongs.player.playingStream,
                                  builder: (context, snapshot) {
                                    bool? playingStage = snapshot.data;
                                    if (playingStage != null && playingStage) {
                                      return const Icon(
                                        Icons.pause_circle_outline,
                                        size: 60,
                                      );
                                    } else {
                                      return const Icon(
                                        Icons.play_circle_outline,
                                        size: 60,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                                highlightColor: Colors.green,
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
                                  color: Colors.white,
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
                                          color: Colors.red,
                                          size: 30,
                                        );
                                      } else {
                                        return const Icon(
                                          Icons.repeat,
                                          color: Colors.white,
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

  void showSliderDialog({
    required BuildContext context,
    required String title,
    required int divisions,
    required double min,
    required double max,
    String valueSuffix = '',
    // TODO: Replace these two by ValueStream.
    required double value,
    required Stream<double> stream,
    required ValueChanged<double> onChanged,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        content: StreamBuilder<double>(
          stream: stream,
          builder: (context, snapshot) => SizedBox(
            height: 100.0,
            child: Column(
              children: [
                Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Fixed',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0)),
                Slider(
                  divisions: divisions,
                  min: min,
                  max: max,
                  value: snapshot.data ?? value,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
