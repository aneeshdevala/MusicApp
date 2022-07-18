import 'package:flutter/material.dart';

class PrivacyPol extends StatelessWidget {
  const PrivacyPol({Key? key}) : super(key: key);

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
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'This privacy policy has been compiled to better serve those who are concerned with how their '
              'Personally Identifiable Information (PII) is used online. PII, as described in US privacy law and '
              'information security, is information that can be used to identify an individual. Please read our '
              'website\'s privacy policy carefully to understand how we collect, use, protect or otherwise handle '
              'your Personally Identifiable Information in accordance with our website\'s privacy policy.',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'What personal information do we collect from the people that visit our blog, website or app?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'When ordering or registering on our site, as appropriate, you may be asked to enter your name, '
              'email address or other details to help you with your experience.\n\nWhen do we collect information?',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'We collect information from you when you register on our site, place an order or enter information '
              'on our site.',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
          ),
        ]),
      ),
    );
  }
}
