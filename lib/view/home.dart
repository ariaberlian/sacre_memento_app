import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 0),
        leading: const Text(
          'Your Treasure',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: CupertinoColors.white),
        ),
        backgroundColor: CupertinoColors.systemBlue,
        trailing: DropdownButtonHideUnderline(
          child: DropdownButton(
            icon: const Icon(Icons.more_vert),
            iconEnabledColor: CupertinoColors.white,

            // TODO MORE MENU
            items: const [
              DropdownMenuItem(
                value: 'cf',
                child: Text('Create Folder'),
              ),
              DropdownMenuItem(
                value: 's',
                child: Text('Sort'),
              ),
            ],
            onChanged: (String? selected) {
              if (selected == 'cf') {
                // TODO BUAT FOLDER BARU
                log('cf');
              } else if (selected == 's') {
                //TODO Sort
                log('s');
              }
            },
          ),
        ),
      ),
      body: ListView(
        children: const [
          //TODO bikin list view card brodieee
        ],
      ),
    );
  }
}
