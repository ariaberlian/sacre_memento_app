import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sacre_memento_app/blocs/select_mode.dart';
import 'package:sacre_memento_app/const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool selectMode = false; //TODO : SELECT MODE
  static var count = 9; //TODO: Change with number of treasure
  var isChecked = List.filled(count, false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SelectModeCubit(),
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          padding: EdgeInsetsDirectional.fromSTEB(15, 5, 15, 0),
          leading: const Text(
            'Your Treasure',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: CupertinoColors.white),
          ),
          backgroundColor: Constant.biru,
          trailing:
              BlocBuilder<SelectModeCubit, Widget>(builder: (context, menu) {
            return DropdownButtonHideUnderline(
              child: menu,
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
              itemCount: count,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Image(
                            image: AssetImage(
                                'assets/welcome_potrait.png')), // TODO: fill with treasure thumbnail
                        title: const Text(
                            'SSNI-432'), // TODO: fill with treasure title
                        subtitle: const Text(
                            '3,42 GB Internal'), //TODO: fill with treasure data
                        onTap: () {
                          //TODO: File open
                          log('sumpah kepencet');
                          setState(() {
                            selectMode ? isChecked[index]?isChecked[index] = false:isChecked[index] = true : log('select off');
                          });
                        },
                        onLongPress: () {
                          // selectmode opened
                          setState(() {
                            selectMode = true;
                            log('pencet lama');
                            isChecked[index] = true;
                          });
                          context
                              .read<SelectModeCubit>()
                              .selectMode(selectMode);
                        },
                        trailing: (selectMode
                            ? Checkbox(
                                value: isChecked[index],
                                onChanged: (context) {
                                  setState(() {
                                    log('kepencet kok ini');
                                    isChecked[index] = context!;
                                  });
                                },
                              )
                            : null),
                      ),
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
