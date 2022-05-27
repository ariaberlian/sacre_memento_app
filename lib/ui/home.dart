import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sacre_memento_app/api/db.dart';
import 'package:sacre_memento_app/api/encryption.dart';
import 'package:sacre_memento_app/blocs/select_mode.dart';
import 'package:sacre_memento_app/const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacre_memento_app/model/treasure.dart';
import 'package:sacre_memento_app/ui/component/more_menu.dart';
import 'package:sacre_memento_app/ui/component/more_select_menu.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static var count = 0;
  static var isChecked = List.filled(Home.count, false);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SelectModeCubit(),
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 0),
          leading: const Text(
            'Your Treasure',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: CupertinoColors.white),
          ),
          backgroundColor: Constant.biru,
          trailing:
              BlocBuilder<SelectModeCubit, bool>(builder: (context, selectOn) {
            return DropdownButtonHideUnderline(
              child: selectOn ? const MoreSelectMenu() : const MoreMenu(),
            );
          }),
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.png'), fit: BoxFit.cover)),
          child: Scrollbar(
            thickness: 8,
            child: FutureBuilder<List<Treasure>>(
                future: DatabaseManager.instance.getTreasure(),
                builder: (context, AsyncSnapshot<List<Treasure>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: Text('Loading...',
                            style: TextStyle(
                                fontSize: 20, color: CupertinoColors.white)));
                  }
                  Home.count = snapshot.data!.length;
                  return snapshot.data!.isEmpty
                      ? const Center(
                          child: Text('You have no treasure',
                              style: TextStyle(
                                  fontSize: 20, color: CupertinoColors.white)),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          separatorBuilder: (context, index) {
                            return Container(
                              height: 8,
                            );
                          },
                          itemCount: Home.count,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Column(
                                children: [
                                  BlocBuilder<SelectModeCubit, bool>(
                                      builder: (context, selectModeOn) {
                                    return ListTile(
                                      leading:
                                          snapshot.data![index].type == 'folder'
                                              ? const Image(
                                                  image: AssetImage(
                                                      'assets/folder.png'))
                                              : Image.file(File(snapshot
                                                  .data![index].thumbnail!)),

                                      //TODO : atur ukuran thumbnail
                                      title: Text(snapshot.data![index].name),
                                      subtitle: Text(
                                          '${snapshot.data![index].size} ${snapshot.data![index].whichmem}'),
                                      onTap: () {
                                        setState(() {
                                          selectModeOn
                                              ? Home.isChecked[index] =
                                                  !Home.isChecked[index]
                                              : log(
                                                  'File Open'); //TODO file/folder open
                                        });
                                      },
                                      onLongPress: () {
                                        // selectmode opened
                                        context
                                            .read<SelectModeCubit>()
                                            .selectMode(true);
                                        setState(() {
                                          Home.isChecked[index] = true;
                                        });
                                      },
                                      trailing: (selectModeOn
                                          ? Checkbox(
                                              value: Home.isChecked[index],
                                              onChanged: (to) {
                                                setState(() {
                                                  Home.isChecked[index] = to!;
                                                });
                                              },
                                            )
                                          : null),
                                    );
                                  }),
                                ],
                              ),
                            );
                          },
                        );
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              String whichmem = 'undecided';

              bool isFolderPick = false;

              await showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('Picker'),
                        content: const Text('What do you want to save?'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Folder'),
                            onPressed: () {
                              setState(() {
                                isFolderPick = true;
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('File'),
                            onPressed: () {
                              setState(() {
                                isFolderPick = false;
                                Navigator.of(context).pop();
                              });
                            },
                          )
                        ],
                      ),
                  barrierDismissible: false);

              String? dir;
              List<File>? files;
              if (isFolderPick) {
                dir = await Encryption.pickDir();
                log('folder taken');
              } else {
                // ignore: use_build_context_synchronously
                files = await Encryption.filepick(context);
                log('file taken');
              }

              // TODO: Dont ask memory selection if they only have 1 memory
              await showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('Memory Selection'),
                        content: const Text('Which memory do you want to use?'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Internal'),
                            onPressed: () {
                              setState(() {
                                whichmem = 'internal';
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('External'),
                            onPressed: () {
                              setState(() {
                                whichmem = 'external';
                                Navigator.of(context).pop();
                              });
                            },
                          )
                        ],
                      ),
                  barrierDismissible: false);

              if (isFolderPick) {
                Encryption.encryptEntireFolder(dir!, whichmem);
                // TODO : reload after encrypt folder
              } else {
                for (var file in files!) {
                  await Encryption.encryptIt(file, whichmem);
                  setState(() {}); // just to reload page
                }
              }
            },
            backgroundColor: Constant.kuning3,
            child: const Icon(
              Icons.add,
            )),
      ),
    );
  }
}
