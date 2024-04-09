import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'app_authentication_settings.db');
      return await openDatabase(path, version: 1, onCreate: _createDatabase);
    } catch (e) {
      print('Erro ao inicializar o banco de dados: $e');
      rethrow;
    }
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users2(
        id SERIAL PRIMARY KEY,
        username TEXT,
        password TEXT
      )
    ''');
  }

  Future<bool> login(String username, String password) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users2',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  Future<void> register(String username, String password) async {
    final Database db = await database;
    await db.insert(
      'users2',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
