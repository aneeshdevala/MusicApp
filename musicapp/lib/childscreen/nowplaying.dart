import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:musicapp/getsongstorage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

import '../Database/favoritebtn.dart';

class NowPlay extends StatefulWidget {
  NowPlay({
    Key? key,
    required this.playerSong,
  }) : super(key: key);

  final List<SongModel> playerSong;
  // final AudioPlayer audioPlayer;
  //int index;

  @override
  State<NowPlay> createState() => _NowPlayState();
}

class _NowPlayState extends State<NowPlay> {
  bool _isPlaying = false;
  bool _nextSong = true;
  int currentIndex = 0;

  @override
  void initState() {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {});
        currentIndex = index;
      }
    });
    playSong();
    super.initState();
  }

  void playSong() {
    GetSongs.player.pause();
    try {
      GetSongs.player.setAudioSource(
          AudioSource.uri(Uri.parse(widget.playerSong[currentIndex].uri!)));
      GetSongs.player.play();
      _isPlaying = true;
    } on Exception {
      Text('OOOOOpppppssss');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
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
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(50),
                            nullArtworkWidget: Image.asset(
                              'assets/undraw_Compose_music_re_wpiw-removebg-preview.png',
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
                        Text(
                          widget.playerSong[currentIndex].displayNameWOExt,
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
                          widget.playerSong[currentIndex].artist.toString() ==
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
                              child: IconButton(
                                  onPressed: () {
                                    // PlayListBtn(
                                    //     song: widget.songModel[widget.index]);
                                  },
                                  icon: const Icon(Icons.shuffle)),
                            ),
                            IconButton(
                                onPressed: (() {
                                  setState(() {
                                    if (currentIndex > 0) {
                                      currentIndex--;
                                    } else {
                                      currentIndex = GetSongs.currentIndex - 1;
                                    }
                                    playSong();
                                  });
                                }),
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
                                onPressed: (() {
                                  setState(() {
                                    if (currentIndex <
                                        widget.playerSong.length - 1) {
                                      currentIndex++;
                                    } else {
                                      currentIndex = 0;
                                    }
                                    playSong();
                                  });
                                }),
                                icon: const Icon(
                                  Icons.skip_next,
                                  size: 50,
                                )),
                            // IconButton(
                            //     onPressed: () {},
                            //     icon: const Icon(Icons.repeat)),

                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: FavoriteBut(
                                  song: widget.playerSong[currentIndex]),
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

  // void changeToSecond(int seconds) {
  //   Duration duration = Duration(seconds: seconds);
  //   widget.audioPlayer.seek(duration);
  // }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
