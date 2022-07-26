import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:musicapp/childscreen/nowplaying.dart';
import 'package:musicapp/getsongstorage.dart';
import 'package:musicapp/widgets/textanimation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  void initState() {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.transparent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      //height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      height: 70,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NowPlay(
                playerSong: GetSongs.playingSongs,
              ),
            ),
          );
        },
        iconColor: const Color.fromARGB(255, 180, 147, 147),
        textColor: const Color.fromARGB(255, 255, 255, 255),
        leading: Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: QueryArtworkWidget(
              artworkQuality: FilterQuality.high,
              artworkFit: BoxFit.fill,
              artworkBorder: BorderRadius.circular(30),
              nullArtworkWidget: Lottie.asset('assets/mini.json'),
              id: GetSongs.playingSongs[GetSongs.player.currentIndex!].id,
              type: ArtworkType.AUDIO,
            ),
          ),
        ),
        title: AnimatedText(
          text: GetSongs
              .playingSongs[GetSongs.player.currentIndex!].displayNameWOExt,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            "${GetSongs.playingSongs[GetSongs.player.currentIndex!].artist}",
            style:
                const TextStyle(fontSize: 11, overflow: TextOverflow.ellipsis),
          ),
        ),
        trailing: FittedBox(
          fit: BoxFit.fill,
          child: Row(
            children: [
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
                    size: 35,
                  )),
              ElevatedButton(
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
                        size: 35,
                      );
                    } else {
                      return const Icon(
                        Icons.play_circle_outline,
                        size: 35,
                      );
                    }
                  },
                ),
              ),
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
                    size: 35,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
