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

  // TODO : Delete actual file after encryption
  static void encryptEntireFolder(String dir, String whichmem,
      {String? parent, String? softparent}) async {

    // Select memory
    Directory mem;
    if (whichmem == 'external') {
      mem = Constant.treasureDir[1];
    } else {
      mem = Constant.treasureDir[0];
    }

    String folderName = basename(dir);

    // encrypt folder name
    final encryptedDirName = encrypter.encrypt(folderName, iv: iv);

    // Make new folder with encrypted name
    String path = parent == null
        ? '${mem.path}/${encryptedDirName.base16}'
        : '${mem.path}/$parent/${encryptedDirName.base16}';
    await Directory(path).create();

    // Get data needed
    String type = 'folder';
    String softpath =
        parent == null ? '/$folderName' : '/$softparent/$folderName';
    Map<String, int> stat = dirStat(dir); //TODO: benerin folder size
    String size = filesize(stat['size']);

    log('name: $folderName');
    log('type: $type');
    log('path : $path');
    log('softpath: $softpath');
    log('whichmem : $whichmem');
    log('size : $size');

    // Add encrypted folder to database
    DatabaseManager.instance.add(Treasure(
        name: folderName,
        type: type,
        path: path,
        softpath: softpath,
        whichmem: whichmem,
        size: size));

    Directory directory = Directory(dir);
    await for (var content in directory.list(recursive: false)) {
      String par =
          parent != null ? '$parent/${basename(path)}' : basename(path);
      String softpar =
          softparent != null ? '$softparent/$folderName' : folderName;
      if (content is Directory) {
        // encrypt folder
        encryptEntireFolder(content.path, whichmem,
            parent: par, softparent: softpar);
      } else if (content is File) {
        // encrypt all file
        await encryptIt(content, whichmem, parent: par, softparent: softpar);
      }
    }
  }

  // For Salsa20 encryption/decryption
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(8);
  static final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));

  // TODO : Delete actual file after encryption
  static Future<File> encryptIt(File file, String whichmem,
      {String? parent, String? softparent}) async {
    Directory dir;
    if (whichmem == 'external') {
      dir = Constant.treasureDir[1];
    } else {
      dir = Constant.treasureDir[0];
    }

    // ignore: prefer_typing_uninitialized_variables
    var encrypted;

    await file
        .readAsBytes()
        .then((value) => encrypted = encrypter.encryptBytes(value, iv: iv));

    log('basename: ${basename(file.path)}');
    // Encrypt file name
    final encryptedfilename = encrypter.encrypt(basename(file.path), iv: iv);

    String pathToFile = (parent == null)
        ? '${dir.path}/${encryptedfilename.base16}'
        : '${dir.path}/$parent/${encryptedfilename.base16}';

    // Encrypt the file
    File encryptedFile = await File(pathToFile).create();
    encryptedFile.writeAsBytes(encrypted.bytes);

    // Get needed data
    String name = basenameWithoutExtension(file.path);
    String ext = extension(file.path);
    String type = '';
    String softpath = softparent == null
        ? '/${basename(file.path)}'
        : '/$softparent/${basename(file.path)}';

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
    log('softpath: $softpath');
    log('whichmem : $whichmem');
    log('size : $size');

    // Add encrypted file to database
    DatabaseManager.instance.add(Treasure(
        name: name,
        thumbnail: thumbnail,
        type: type,
        extention: ext,
        path: pathToFile,
        softpath: softpath,
        whichmem: whichmem,
        size: size));

    return encryptedFile;
  }

  static Future<File> decryptIt(File file) async {
    // TODO: implement decrypt

    var content = encrypt.Encrypted(await file.readAsBytes());
    var name = encrypt.Encrypted.fromBase16(basename(file.path));

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

  static Map<String, int> dirStat(String dirPath) {
    int fileNum = 0;
    int totalSize = 0;
    var dir = Directory(dirPath);
    try {
      if (dir.existsSync()) {
        dir
            .list(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            fileNum++;
            totalSize += entity.lengthSync();
          } else if (entity is Directory) {
            Map<String, int> result = dirStat(entity.path);
            fileNum += result['fileNum']!;
            totalSize += result['size']!;
          }
        });
      }
    } catch (e) {
      log(e.toString());
    }

    return {'fileNum': fileNum, 'size': totalSize};
  }
}
