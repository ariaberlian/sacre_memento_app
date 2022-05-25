import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sacre_memento_app/blocs/select_mode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreSelectMenu extends StatelessWidget {
  const MoreSelectMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      icon: const Icon(Icons.more_vert),
      iconEnabledColor: CupertinoColors.white,
      autofocus: true,

      items: [
        DropdownMenuItem(
          value: 'cf',
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.create_new_folder),
                  Text('New Folder'),
                ]),
          ),
        ),
        DropdownMenuItem(
          value: 'rn',
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.edit),
                  Text('Rename'),
                ]),
          ),
        ),
        DropdownMenuItem(
          value: 'cp',
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.copy),
                  Text('Copy'),
                ]),
          ),
        ),
        DropdownMenuItem(
          value: 'mv',
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.cut),
                  Text('Move'),
                ]),
          ),
        ),
        DropdownMenuItem(
          value: 'rs',
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.restore),
                  Text('Restore'),
                ]),
          ),
        ),
        DropdownMenuItem(
          value: 'dl',
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.delete_forever),
                  Text('Delete'),
                ]),
          ),
        ),
        DropdownMenuItem(
          value: 'us',
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.check_box_outline_blank),
                  Text('UnSelect'),
                ]),
          ),
        ),
      ],
      onChanged: (String? selected) {
        if (selected == 'cf') {
          // TODO BUAT FOLDER BARU
          log('cf');
        } else if (selected == 'rn') {
          //TODO: Buat rename
          log('rn');
        } else if (selected == 'cp') {
          //TODO: Buat copy
          log('cp');
        } else if (selected == 'mv') {
          //TODO: buat move
          log('mv');
        } else if (selected == 'rs') {
          //TODO: buat restore
          log('rs');
        } else if (selected == 'dl') {
          //TODO: buat delete
          log('dl');
        } else if (selected == 'us') {
          context.read<SelectModeCubit>().selectMode(false);
        }
      },
    );
  }
}
