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
                                      leading: Image(
                                          image: AssetImage(
                                              snapshot.data![index].thumbnail)),
                                      title: Text(snapshot.data![index].name),
                                      subtitle: Text(
                                          '${snapshot.data![index].size} ${snapshot.data![index].whichmem}'),
                                      onTap: () {
                                        //TODO: File open
                                        setState(() {
                                          selectModeOn
                                              ? Home.isChecked[index] =
                                                  !Home.isChecked[index]
                                              : log(
                                                  'File Open'); //TODO file open
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
              // TODO: FILE PICKER

              String? dir = await Encryption.pickDir();
              log(dir!);

              // await DatabaseManager.instance.add(
              //   const Treasure(id: 11, name: 'ahh', thumbnail: 'assets/welcome_potrait.png', type: 'Photo', extention: 'jpg', path: 'there/here', softpath: 'there/rightThere', whichmem: 'internal', size: 3000)
              // );
              // setState(() {
              // });
            },
            backgroundColor: Constant.kuning3,
            child: const Icon(
              Icons.add,
            )),
      ),
    );
  }
}
