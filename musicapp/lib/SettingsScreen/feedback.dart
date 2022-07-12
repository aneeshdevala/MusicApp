import 'package:flutter/material.dart';

class FeedBack extends StatelessWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFDD4C4C), Color.fromARGB(255, 255, 255, 255)],
            stops: [0.5, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text('Feedback'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Feedback'),
        ),
      ),
    );
  }
}
