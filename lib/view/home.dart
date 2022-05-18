import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sacre_memento_app/main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var count = 9; //TODO: Change with number of treasure
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
        backgroundColor: MyApp.biru,
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
                _showActionSheet(context);
              }
            },
          ),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/bg.png'), fit: BoxFit.cover)),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          separatorBuilder: (context, index) {
            return Container(
              height: 8,
            );
          },
          itemCount: count,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Image(
                        image: AssetImage(
                            'assets/welcome_potrait.png')), // TODO: fill with treasure thumbnail
                    title: Text('SSNI-432'), // TODO: fill with treasure title
                    subtitle: Text(
                        '3,42 GB Internal'), //TODO: fill with treasure data
                    // ontap: (){TODO: File open}
                    // onLongPress: (){TODO: select and more menu}
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: FILE PICKER
          },
          backgroundColor: MyApp.kuning3,
          child: const Icon(
            Icons.add,
          )),
    );
  }

  //TODO: Sort
  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
              title: const Text('Sort By'),
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () {
                      // TODO: SORT BY NAME(A-Z)
                    },
                    child: const Text('Name (A-Z)')),
                CupertinoActionSheetAction(
                    onPressed: () {
                      // TODO: SORT BY SIZE (big - small)
                    },
                    child: const Text('Size (big - small)')),
                CupertinoActionSheetAction(
                    onPressed: () {
                      // TODO: SORT BY Time(new - old)
                    },
                    child: const Text('Time (new - old)')),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ));
  }
}
