import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musicapp/childscreen/nowplaying.dart';
import 'package:musicapp/getsongstorage.dart';

class MiniPlayer extends StatefulWidget {
  MiniPlayer({Key? key}) : super(key: key);

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
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NowPlay(
                  playerSong: [],
                ),
              ),
            );
          },
        ));
  }
}
