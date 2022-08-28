import 'package:flutter/material.dart';

class PrivacyPol extends StatelessWidget {
  const PrivacyPol({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 156, 0, 78),
          Color.fromARGB(255, 0, 0, 0)
        ], stops: [
          0.5,
          1
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text('Privacy Policy'),
          centerTitle: true,
        ),
        body: ListView(children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
              'https://docs.google.com/document/d/1rRdGvaprPcgvq1EjptwZwX9d6L9PU4L8u8dsPumMQKs/edit?usp=sharing')
        ]),
      ),
    );
  }
}
