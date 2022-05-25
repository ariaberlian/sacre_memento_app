import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:sacre_memento_app/api/db.dart';
import 'package:sacre_memento_app/api/thumbnail_extract.dart';
import 'package:sacre_memento_app/const.dart';
import 'package:path/path.dart';
import 'package:sacre_memento_app/model/treasure.dart';
import 'package:filesize/filesize.dart';

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
        'gif',
        'mov',
        'avi',
        'flv',
        'm4p',
        'm4v',
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
  static final iv = encrypt.IV.fromLength(8);
  static final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));

  static Future<File> encryptIt(File file, String whichmem) async {
    Directory dir;
    if (whichmem == 'external') {
      dir = Constant.treasureDir[1];
    } else {
      dir = Constant.treasureDir[0];
    }

    var encrypted;

    await file
        .readAsBytes()
        .then((value) => encrypted = encrypter.encryptBytes(value, iv: iv));

    log('basename: ${basename(file.path)}');
    // Encrypt file name
    final encryptedfilename = encrypter.encrypt(basename(file.path), iv: iv);
    String pathToFile = '${dir.path}/${encryptedfilename.base64}';
    // Encrypt the file
    File encryptedFile = await File(pathToFile).writeAsBytes(encrypted.bytes);

    // Get needed data
    String name = basenameWithoutExtension(file.path);
    String ext = extension(file.path);
    String type = '';

    if (ext == '.mp4' ||
        ext == '.mkv' ||
        ext == '.mov' ||
        ext == '.avi' ||
        ext == '.flv' ||
        ext == '.m4p' ||
        ext == '.m4v') {
      type = 'video';
    } else {
      type = 'image';
    }

    String thumbnail = await ThumbnailExtractor.extract(file, type, name);
    String size = filesize(file.lengthSync());

    log('name: $name');
    log('thumbnail : $thumbnail');
    log('type: $type');
    log('ext : $ext');
    log('path : $pathToFile');
    log('softpath: /${basename(file.path)}');
    log('whichmem : $whichmem');
    log('size : $size');

    // Add encrypted file to database
    DatabaseManager.instance.add(Treasure(
        name: name,
        thumbnail: thumbnail,
        type: type,
        extention: ext,
        path: pathToFile,
        softpath: '/${basename(file.path)}', // TODO : make soft path
        whichmem: whichmem,
        size: size));

    return encryptedFile;
  }

  static Future<File> decryptIt(File file) async {
    // TODO: implement decrypt

    var content = encrypt.Encrypted(await file.readAsBytes());
    var name = encrypt.Encrypted(base64Decode(basename(file.path)));

    var contentName = encrypter.decrypt(name, iv: iv);
    final decrypted = encrypter.decryptBytes(content, iv: iv);
    // File decryptedFile = await File('${Constant.treasureDir[1]}/$contentName')
    //     .writeAsBytes(decrypted);

    log('${Constant.treasureDir[1].path}/$contentName');

    File decryptedFile =
        await File('${Constant.treasureDir[1].path}/$contentName').create();

    decryptedFile = await decryptedFile.writeAsBytes(decrypted);

    return decryptedFile;
  }

  static File readFileFromDir(String dir) {
    // TODO: implement readFileFromDir
    throw UnimplementedError();
  }

  static void writeFile(File file) {
    // TODO: implement writeFile
  }
}
