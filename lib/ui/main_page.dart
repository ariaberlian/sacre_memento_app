import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sacre_memento_app/const.dart';
import 'package:sacre_memento_app/ui/home.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        height: 60,
        activeColor: CupertinoColors.white,
        inactiveColor: CupertinoColors.opaqueSeparator,
        backgroundColor: Constant.biru,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_max_outlined)),
          BottomNavigationBarItem(
              icon: Icon(Icons.download_for_offline_outlined)),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          // HOME
          case 0:
            return const Home();

          // DOWNLOAD PAGE
          // case 1:
          //   break;
          default:
            return const Home();
        }
      },
    );
  }
}