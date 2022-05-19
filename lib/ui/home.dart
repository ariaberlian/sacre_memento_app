import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sacre_memento_app/blocs/select_mode.dart';
import 'package:sacre_memento_app/const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacre_memento_app/ui/component/more_menu.dart';
import 'package:sacre_memento_app/ui/component/more_select_menu.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static var count = 9; //TODO: Change with number of treasure
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
            child: ListView.separated(
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
                          leading: const Image(
                              image: AssetImage(
                                  'assets/welcome_potrait.png')), // TODO: fill with treasure thumbnail
                          title: const Text(
                              'SSNI-432'), // TODO: fill with treasure title
                          subtitle: const Text(
                              '3,42 GB Internal'), //TODO: fill with treasure data
                          onTap: () {
                            //TODO: File open
                            setState(() {
                              selectModeOn
                                  ? Home.isChecked[index] =
                                      !Home.isChecked[index]
                                  : log('File Open'); //TODO file open
                            });
                          },
                          onLongPress: () {
                            // selectmode opened
                            log('pencet lama');
                            context.read<SelectModeCubit>().selectMode(true);
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
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: FILE PICKER
            },
            backgroundColor: Constant.kuning3,
            child: const Icon(
              Icons.add,
            )),
      ),
    );
  }
}
