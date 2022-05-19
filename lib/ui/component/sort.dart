import 'package:flutter/cupertino.dart';

class SortByActionSheet {
  SortByActionSheet(BuildContext context) {
    _showActionSheet(context);
  }
  //TODO: Sort
  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
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
            ),
        context: context);
  }
}
