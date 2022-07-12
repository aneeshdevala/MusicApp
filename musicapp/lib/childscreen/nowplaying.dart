import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicapp/Database/favoritedb.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

import '../Database/favoritebtn.dart';
import '../homescreen.dart';

class NowPlay extends StatefulWidget {
  NowPlay(
      {Key? key,
      required this.songModel,
      required this.audioPlayer,
      required this.index,
      required List<SongModel> song})
      : super(key: key);

  final List<SongModel> songModel;
  final AudioPlayer audioPlayer;
  int index;

  @override
  State<NowPlay> createState() => _NowPlayState();
}

class _NowPlayState extends State<NowPlay> {
  //song resumeplay
  // Duration _duration = const Duration();
  // Duration _position = const Duration();
  bool _isPlaying = false;
  @override
  void initState() {
    // TODO: implement initState
    playSong();
  }

  void playSong() {
    try {
      widget.audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(widget.songModel[widget.index].uri!),
        tag: MediaItem(
          id: '${widget.songModel[widget.index].id}',
          album: "${widget.songModel[widget.index].album}",
          title: widget.songModel[widget.index].displayNameWOExt,
          artUri: Uri.parse('https://example.com/albumart.jpg'),
        ),
      ));
      widget.audioPlayer.play();
      _isPlaying = true;
    } on Exception {
      log("cannot parse song");
    }
  }

  @override
  Widget build(BuildContext context) {
    FavoriteDB.favoriteSongs.notifyListeners();
    // return ValueListenableBuilder(
    //     valueListenable: FavoriteDB.favoriteSongs,
    //     builder: (BuildContext ctx, List<SongModel> favorData, Widget? child) {
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
                        Container(
                          height: 400,
                          width: 300,
                          child: QueryArtworkWidget(
                            id: widget.songModel[widget.index].id,
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(50),
                            nullArtworkWidget: const Icon(
                              Icons.music_note_outlined,
                              size: 200,
                            ),
                            //   artworkWidth: 300,
                            //   artworkHeight: 400,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.songModel[widget.index].displayNameWOExt,
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
                          widget.songModel[widget.index].artist.toString() ==
                                  "<unknown>"
                              ? "Unknown Artist"
                              : widget.songModel[widget.index].artist
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
                                    widget.audioPlayer.seek(duration);
                                  });
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.queue_music)),
                            IconButton(
                                onPressed: (() {
                                  setState(() {
                                    if (widget.index > 0) {
                                      widget.index--;
                                    } else {
                                      widget.index =
                                          widget.songModel.length - 1;
                                    }
                                    playSong();
                                  });
                                }),
                                icon: const Icon(
                                  Icons.skip_previous,
                                  size: 40,
                                )),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (_isPlaying) {
                                      widget.audioPlayer.pause();
                                    } else {
                                      widget.audioPlayer.play();
                                    }
                                    _isPlaying = !_isPlaying;
                                  });
                                },
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 40,
                                )),
                            IconButton(
                                onPressed: (() {
                                  setState(() {
                                    if (widget.index <
                                        widget.songModel.length - 1) {
                                      widget.index++;
                                    } else {
                                      widget.index = 0;
                                    }
                                    playSong();
                                  });
                                }),
                                icon: const Icon(
                                  Icons.skip_next,
                                  size: 40,
                                )),
                            FavoriteBut(song: widget.songModel[widget.index]),
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
          widget.audioPlayer.positionStream,
          widget.audioPlayer.durationStream,
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
