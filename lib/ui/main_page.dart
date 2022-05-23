import 'dart:developer';
import 'dart:io';

import 'package:external_path/external_path.dart';
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
    final status = await Permission.manageExternalStorage.status;
    setState(() {});
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

        break;
    }
  }

  Future<void> requestForPermission() async {
    //requesting storage permission
    final status = await Permission.manageExternalStorage.request();
    await Permission.storage.request();
    await getPath();

    setState(() {
      permissionStatus = status;
    });
  }

  Future<void> getPath() async {
    List<String> paths;
    // getExternalStorageDirectories() will return list containing internal storage directory path
    // And external storage (SD card) directory path (if exists)
    paths = await ExternalPath.getExternalStorageDirectories();
    log("lagi ambil external path");
    for (var element in paths) {
      log(element);
    }
    Constant.treasureDir = await initTreasureBox(paths);
    setState(() {});
  }

  Future<List<Directory>> initTreasureBox(List<String> place) async {
    List<Directory> dir = [];
    log("lagi init treasure box");
    for (var i = 0; i < place.length; i++) {
      log(i.toString());
      dir.add(await Directory('${place[i]}/.System/kernel').create(recursive: true));
    }
    log('treasurebox udah jadi');
    return dir;
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
