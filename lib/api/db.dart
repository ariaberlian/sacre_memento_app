import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sacre_memento_app/model/treasure.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  DatabaseManager._private();

  static DatabaseManager instance = DatabaseManager._private();
  Database? _db;

  Future<Database> get db async {
    _db ??= await _initDb();

    return _db!;
  }

  Future _initDb() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, 'sacrememento.db');
    return await openDatabase(path, version: 1,
        onCreate: (database, version) async {
      return await database.execute('''
          CREATE TABLE treasure(
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           name TEXT NOT NULL,
           thumbnail TEXT,
           type varchar(10) NOT NULL,
           extention VARCHAR(10),
           path TEXT NOT NULL,
           softpath TEXT NOT NULL,
           whichmem VARCHAR(10) NOT NULL,
           size INTEGER,
           time_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP
           );
        ''');
    });
  }

  Future closeDB() async {
    _db = await instance.db;
    _db!.close();
  }

  Future<List<Treasure>> getTreasure() async {
    Database db = await instance.db;
    var treasures = await db.query(
      'treasure',
      orderBy: 'type',
    );

    List<Treasure> treasureList;
    treasureList = treasures.isNotEmpty
        ? treasures.map((e) => Treasure.fromMap(e)).toList()
        : [];

    return treasureList;
  }

  Future<int> add(Treasure treasure) async {
    Database db = await instance.db;
    log('otw tambah data');
    return await db.insert('treasure', treasure.toMap());
  }

  Future<int> delete(int id) async {
    Database db = await instance.db;
    return db.delete('treasure', where: 'id=?', whereArgs: [id]);
  }

}
