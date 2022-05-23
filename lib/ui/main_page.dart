import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sacre_memento_app/const.dart';
import 'package:sacre_memento_app/ui/home.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
    
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
   late Permission permission;
  PermissionStatus permissionStatus = PermissionStatus.denied;

  void _listenForPermission() async {
    final status = await Permission.storage.status;
    setState(() {
      permissionStatus = status;
    });
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();
        log("access denied");
        break;
      case PermissionStatus.granted:
        //Do nothing
        log("access granted");
        break;
      case PermissionStatus.limited:
        log("access limited");
        Navigator.pop(context);
        break;
      case PermissionStatus.restricted:
        log("access restricted");
        Navigator.pop(context);
        break;

      case PermissionStatus.permanentlyDenied:
        log("access permanentlydenied");
        Navigator.pop(context);
        break;
    }
  }

  Future<void> requestForPermission() async {
    //requesting storage permission
    final status = await Permission.storage.request();
    setState(() {
      permissionStatus = status;
    });
  }

  @override
  void initState() {
    _listenForPermission();
    super.initState();
  }




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
