import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: RichText(
        text: TextSpan(
          text: 'm u s i c ',
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.grey[350]),
          children: const <TextSpan>[
            TextSpan(
                text: 'A',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                    color: Colors.green)),
          ],
        ),
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
            ),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
      ],
    );
  }
}
