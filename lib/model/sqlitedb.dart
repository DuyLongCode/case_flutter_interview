import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelper with ChangeNotifier{
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;
  final _lock = Lock();

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    String path = join(await getDatabasesPath(), 'my_database.db');
    print(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY, names TEXT, prices REAL, urls TEXT)',
        );
      },
    );
  }

  Future<void> _insertData(List<Map<String, dynamic>> products) async {
    await _lock.synchronized(() async {
      final db = await database;
      Batch batch = db.batch();
      for (var product in products) {
        batch.insert('products', product, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> insertData(List<Map<String, dynamic>> products) async {
    await _insertData(products);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> _getProducts({int limit = 10000}) async {
  return await _lock.synchronized(() async {
    final db = await database;
    return await db.query(
      'products',
      orderBy: 'id DESC',
      limit: limit,
    );
  });
}


  Future<List<Map<String, dynamic>>> getProducts() async {
        notifyListeners();
    return await _getProducts();
  }

  Future<void> _deleteProduct(int id) async {
    await _lock.synchronized(() async {
      final db = await database;
      await db.delete('products', where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<void> deleteProduct(int id) async {
    await _deleteProduct(id);
  }
}