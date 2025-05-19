import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;

  static Database? _db;

  DBService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        index INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT NOT NULL UNIQUE,
        description TEXT,
        dateTime TEXT,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT
      )
    ''');
  }

  // 🔄 Create
  Future<int> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('tasks', item);
  }

  // 📥 Read All
  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query('tasks');
  }

  // 📤 Read One
  Future<Map<String, dynamic>?> getItem(int id) async {
    final db = await database;
    final result = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // ✏️ Update
  Future<int> updateItem(int id, Map<String, dynamic> item) async {
    final db = await database;
    return await db.update('tasks', item, where: 'id = ?', whereArgs: [id]);
  }

  // ❌ Delete
  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // 🧹 Clear Table
  Future<void> clearTable() async {
    final db = await database;
    await db.delete('tasks');
  }

  // 🧨 Close
  Future close() async {
    final db = await database;
    db.close();
  }
}
