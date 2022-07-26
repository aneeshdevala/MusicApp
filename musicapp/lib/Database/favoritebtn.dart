import 'package:flutter/material.dart';
import 'package:musicapp/Database/favoritedb.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteBut extends StatefulWidget {
  const FavoriteBut({Key? key, required this.song}) : super(key: key);
  final SongModel song;

  @override
  State<FavoriteBut> createState() => _FavoriteButState();
}

class _FavoriteButState extends State<FavoriteBut> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDB.favoriteSongs,
        builder: (BuildContext ctx, List<SongModel> favorData, Widget? child) {
          return IconButton(
            onPressed: () {
              if (FavoriteDB.isfavor(widget.song)) {
                FavoriteDB.delete(widget.song.id);
                //FavoriteDB.favoriteSongs.notifyListeners();

                const snackBar = SnackBar(
                  content: Text(
                    'Removed From Favorite',
                    style: TextStyle(color: Color.fromARGB(255, 247, 247, 247)),
                  ),
                  duration: Duration(milliseconds: 1500),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                FavoriteDB.add(widget.song);
                //   FavoriteDB.favoriteSongs.notifyListeners();
                const snackbar = SnackBar(
                  backgroundColor: Colors.black,
                  content: Text(
                    'Song Added to Favorite',
                    style: TextStyle(color: Colors.white),
                  ),
                  duration: Duration(milliseconds: 350),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }

              FavoriteDB.favoriteSongs.notifyListeners();
            },
            icon: FavoriteDB.isfavor(widget.song)
                ? Icon(
                    Icons.favorite,
                    color: Colors.red[900],
                  )
                : Icon(
                    Icons.favorite_border,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
          );
        });
  }
}
