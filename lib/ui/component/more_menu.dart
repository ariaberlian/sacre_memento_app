import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sacre_memento_app/ui/component/sort.dart';

class MoreMenu extends StatelessWidget {
  const MoreMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      icon: const Icon(Icons.more_vert),
      iconEnabledColor: CupertinoColors.white,

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
          value: 's',
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.sort),
                  Text('Sort'),
                ]),
          ),
        ),
      ],
      onChanged: (String? selected) {
        if (selected == 'cf') {
          // TODO BUAT FOLDER BARU
          log('cf');
        } else if (selected == 's') {
          SortByActionSheet(context);
        }
      },
    );
  }
}
