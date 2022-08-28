import 'package:flutter/material.dart';
import 'package:musicapp/Controller/DbProviders/favdatabase_provider.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoriteBut extends StatelessWidget {
  const FavoriteBut({Key? key, required this.song}) : super(key: key);
  final SongModel song;

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteDB>(builder: (context, value, child) {
      return IconButton(
        onPressed: () {
          if (value.isfavor(song)) {
            value.delete(song.id);

            Provider.of<FavoriteDB>(context, listen: false).notifyListeners();
            const snackBar = SnackBar(
              content: Text(
                'Removed From Favorite',
                style: TextStyle(color: Color.fromARGB(255, 247, 247, 247)),
              ),
              duration: Duration(milliseconds: 1500),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            value.add(song);
            Provider.of<FavoriteDB>(context, listen: false).notifyListeners();

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

          Provider.of<FavoriteDB>(context, listen: false).notifyListeners();
        },
        icon: value.isfavor(song)
            ? Icon(
                Icons.favorite,
                color: Colors.red[900],
              )
            : const Icon(
                Icons.favorite_border,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
      );
    });
  }
}
