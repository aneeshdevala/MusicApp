import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

Widget shareFile(BuildContext context) {
  return Scaffold(
    body: FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 30), () {
        return Share.share('check out this app');
      }),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.data;
      },
    ),
  );
}
