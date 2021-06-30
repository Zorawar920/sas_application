import 'dart:io' as io;
import 'package:sas_application/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  late final Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'user.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE user(id INTEGER PRIMARY KEY, countryCode TEXT, phonenumber INTEGER, age INTEGER, firstName TEXT, lastName TEXT, emergencyContact1 TEXT, emergencyContact2 TEXT, emergencyContact3 TEXT, gender TEXT, email TEXT, password TEXT, googleSignIn TEXT)');
  }

  Future<void> insertUser(UserModel userModel) async {
    var dbClient = await db;
    await dbClient.insert('user', userModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
    //return userModel;
  }

  Future<List<UserModel>> retrieve() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps =
        await dbClient.query('user', columns: [
      'id',
      'countryCode',
      'phonenumber',
      'age',
      'firstName',
      'lastName',
      'emergencyContact1',
      'emergencyContact2',
      'emergencyContact3',
      'gender',
      'email',
      'password',
      'googleSignIn'
    ]);
    List<UserModel> userModel = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        userModel.add(UserModel.fromMap(maps[i]));
      }
    }
    return userModel;
  }

  Future<int> delete(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateUser(UserModel userModel) async {
    final dbClient = await db;
    return await dbClient.update('user', userModel.toMap(),
        where: 'id = ?', whereArgs: [userModel.id]);
  }

  Future close() async {
    final dbClient = await db;
    dbClient.close();
  }
}
