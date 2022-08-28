import 'package:flutter/material.dart';
import 'package:musicapp/Controller/DbProviders/playlsitsongdb_prov.dart';
import 'package:musicapp/View/Settings/widgets/sharefile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    {
      return Drawer(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 156, 0, 78),
            Color.fromARGB(255, 0, 0, 0)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                leading: const Icon(Icons.message_outlined),
                title: const Text(
                  'Feedback',
                ),
                onTap: () {
                  _email();
                },
              ),
              ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share this App'),
                onTap: () {
                  shareFile(context);
                },
              ),
              const ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                leading: Icon(Icons.lock),
                title: Text('Privacy Policy'),
              ),
              ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                leading: const Icon(Icons.star_border_outlined),
                title: const Text('Rate this App'),
                onTap: () {
                  _ratingApp();
                },
              ),
              ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                leading: const Icon(Icons.restore),
                title: const Text('Reset App'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Reset App'),
                          content: const Text(
                              'Are you sure you want to reset the app?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('Reset'),
                              onPressed: () {
                                Provider.of<PlayListDb>(context, listen: false)
                                    .appReset(context);
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
              ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                leading: const Icon(Icons.info_outlined),
                title: const Text('About Developer'),
                onTap: () {
                  _aboutdeveloper();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'v.1.0.0',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }

  Future<void> _email() async {
    // ignore: deprecated_member_use
    if (await launch('mailto:aneesh172.ant@gmail.com')) {
      throw "Try Again";
    }
  }

  Future<void> _aboutdeveloper() async {
    // ignore: deprecated_member_use
    if (await launch(
        'https://aneeshdevala.github.io/Protfolio-Personalwebsite/')) {
      throw "Try Again";
    }
  }

  Future<void> _ratingApp() async {
    // ignore: deprecated_member_use
    if (await launch(
        'https://play.google.com/store/apps/details?id=in.brototype.music_app')) {
      throw "Try Again";
    }
  }
}
