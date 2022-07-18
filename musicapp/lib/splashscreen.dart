import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/bottomscreen.dart';
// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/Musifyofficial.png'),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      nextScreen: const BottomScreens(),
      duration: 2000,
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
