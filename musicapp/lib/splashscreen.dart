import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/bottomscreen.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/Musifyofficial.png'),
      backgroundColor: Colors.red,
      nextScreen: BottomScreens(),
      duration: 2000,
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
      animationDuration: Duration(seconds: 1),
    );
  }
}
