import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    try {
      _database = await _initDatabase();
      return _database;
    } catch (e) {
      // Tratar erros de inicialização do banco de dados aqui
      print('Erro ao inicializar o banco de dados: $e');
      rethrow; // Reenviar a exceção para que ela possa ser tratada em outro lugar, se necessário
    }
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'app_authentication_settings.db');
      return await openDatabase(path, version: 1, onCreate: _createDatabase);
    } catch (e) {
      // Tratar erros de inicialização do banco de dados aqui
      print('Erro ao inicializar o banco de dados: $e');
      rethrow; // Reenviar a exceção para que ela possa ser tratada em outro lugar, se necessário
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT
      )
    ''');
  }

  Future<bool> login(String username, String password) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  Future<void> register(String username, String password) async {
    final Database db = await database;
    await db.insert(
      'users',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
