import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

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
    return null;
  }

  static Future<String?> pickDir() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      // User canceled the picker
    }
    return selectedDirectory;
  }

  // For AES encryption/decryption
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static Future<File> encryptIt(File file, String whichmem) async {
    //TODO : directory
    Directory dir;
    if (whichmem == 'internal') {
      dir = Directory('storage/emulated/0/');
    } else {
      dir = Directory('storage/emulated/1/');
    }

    String content = file.open().toString();
    final encrypted = encrypter.encrypt(content, iv: iv);

    log('encrypted bytes  : ${encrypted.bytes.toString()}');
    log('encrypted base16 : ${encrypted.base16}');
    log('encrypted base64 : ${encrypted.base64}');

    File encryptedFile = await File(dir.path).writeAsBytes(encrypted.bytes);
    return encryptedFile;
  }

  static File decryptIt(File file) {
    // TODO: implement decrypt
    throw UnimplementedError();
  }

  static File readFileFromDir(String dir) {
    // TODO: implement readFileFromDir
    throw UnimplementedError();
  }

  static void writeFile(File file) {
    // TODO: implement writeFile
  }
}
