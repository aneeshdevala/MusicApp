// import 'package:flutter/material.dart';
// import 'package:musicapp/Database/playlsitsongdb.dart';
// import 'package:musicapp/Database/playlistfoldb.dart';

// import 'package:on_audio_query/on_audio_query.dart';

// class PlayListBtn extends StatefulWidget {
//   const PlayListBtn({Key? key, required this.song}) : super(key: key);
//   final SongModel song;

//   @override
//   State<PlayListBtn> createState() => _PlayListBtnState();
// }

// class _PlayListBtnState extends State<PlayListBtn> {
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         if (PlayList.isPlayList(widget.song)) {
//           PlayList.delete(widget.song.id);
//           // setState(() {});
//           playlistnotifier.notifyListeners();
//           const snackBar = SnackBar(
//               content: Text(
//             'Removed From playlist',
//             style: TextStyle(color: Color.fromARGB(255, 247, 247, 247)),
//           ));
//           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//         } else {
//           PlayList.add(widget.song);
//           // playlistnotifier.notifyListeners();
//           const snackbar = SnackBar(
//             backgroundColor: Colors.black,
//             content: Text(
//               'Song Added to playlist',
//               style: TextStyle(color: Colors.white),
//             ),
//           );
//           ScaffoldMessenger.of(context).showSnackBar(snackbar);
//           // }
//         }
//       },
//       icon: const Icon(
//         Icons.playlist_add,
//         color: Color.fromARGB(255, 255, 255, 255),
//       ),
//     );
//   }
// }
