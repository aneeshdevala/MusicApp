import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

Widget shareFile(BuildContext context) {
  return Scaffold(
    body: FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 30), () {
        return Share.share(
            'https://play.google.com/store/apps/details?id=in.brototype.music_app');
      }),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.data;
      },
    ),
  );
}
