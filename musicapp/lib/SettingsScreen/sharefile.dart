// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';

// class ShareFile extends StatelessWidget {
//   const ShareFile({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//      body: Share.share('check out this app'),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
