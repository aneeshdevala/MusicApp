import 'package:flutter/material.dart';

import 'package:musicapp/childscreen/nowplaying.dart';
import 'package:musicapp/getsongstorage.dart';
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
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      //height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.8,
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
        iconColor: Colors.black,
        textColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.only(left: 1),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: QueryArtworkWidget(
              artworkBorder: BorderRadius.circular(30),
              nullArtworkWidget: const Icon(
                Icons.music_note,
                size: 40,
              ),
              artworkHeight: 400,
              artworkWidth: 400,
              id: GetSongs.playingSongs[GetSongs.player.currentIndex!].id,
              type: ArtworkType.AUDIO,
            ),
          ),
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            GetSongs.playingSongs[GetSongs.currentIndes].displayNameWOExt,
            style:
                const TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis),
          ),
        ),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            "${GetSongs.playingSongs[GetSongs.currentIndes].artist}",
            style:
                const TextStyle(fontSize: 11, overflow: TextOverflow.ellipsis),
          ),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: Colors.black,
              onPrimary: Colors.green),
          onPressed: () async {
            if (GetSongs.player.playing) {
              await GetSongs.player.pause();
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
      ),
    );
  }
}
