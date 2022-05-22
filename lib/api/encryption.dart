import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Encryption {
  static Future<List<File>?> filepick(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
        'jpeg',
        'mp4',
        'mkv',
        'ogg',
        'gif',
        'mov',
        'avi',
        'flv',
        'm4p',
        'm4v',
        ''
      ],
    );
    List<File> files;
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      return files;
    }
    // else {
    //   // User canceled the picker
    //   Navigator()
    // }
    return null;
  }

  static Future<String?> pickDir() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      // User canceled the picker
    }
    return selectedDirectory;
  }

  
}
