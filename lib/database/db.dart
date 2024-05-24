import 'package:sqflite/sqflite.dart';

class DB {
  DB._();

  static final DB instance = DB._();

  static Database? _database;

  DB._initDB();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('database.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE user (
      ssn TEXT PRIMARY KEY
    )
  ''');

    await db.execute('''
    CREATE TABLE productFavorite (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      numberProduct INTEGER,
      userSsn TEXT,
      FOREIGN KEY (userSsn) REFERENCES user(ssn)
    )
  ''');

    await db.execute('''
    CREATE TABLE productCart (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      numberProduct INTEGER,
      count INTEGER DEFAULT 1,
      userSsn TEXT,
      FOREIGN KEY (userSsn) REFERENCES user(ssn)
    )
  ''');
  }


  Future<void> createUser(String ssn) async {
    final db = await database;
    await db.insert('user', {'ssn': ssn});
  }

  Future<void> createProductFavorite(int numberProduct, String ssn) async {
    final db = await database;
    await db.insert('productFavorite', {'numberProduct': numberProduct, 'userSsn': ssn});
  }

  Future<void> createProductCart(int numberProduct, String ssn) async {
    final db = await database;
    await db.insert('productCart', {'numberProduct': numberProduct, 'userSsn': ssn});
  }

  Future<List<String>> readAllFavorites(String ssn) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('productFavorite', where: 'userSsn = ?', whereArgs: [ssn]);
    return List.generate(maps.length, (i) => maps[i]['numberProduct'].toString());
  }

  Future<List<String>> readAllCart(String ssn) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('productCart', where: 'userSsn = ?', whereArgs: [ssn]);
    return List.generate(maps.length, (i) => maps[i]['numberProduct'].toString());
  }

  Future<void> deleteProductFavorite(int numberProduct, String ssn) async {
    final db = await database;
    await db.delete('productFavorite', where: 'numberProduct = ? AND userSsn = ?', whereArgs: [numberProduct, ssn]);
  }

  Future<void> deleteProductCart(int numberProduct, String ssn) async {
    final db = await database;
    await db.delete('productCart', where: 'numberProduct = ? AND userSsn = ?', whereArgs: [numberProduct, ssn]);
  }

  Future<bool> existFavorite(int numberProduct, String ssn) async {
    final db = await database;
    final result = await db.query(
      'productFavorite',
      where: 'numberProduct = ? AND userSsn = ?',
      whereArgs: [numberProduct, ssn],
    );
    return result.isNotEmpty;
  }

  Future<bool> existCart(int numberProduct, String ssn) async {
    final db = await database;
    final result = await db.query(
      'productCart',
      where: 'numberProduct = ? AND userSsn = ?',
      whereArgs: [numberProduct, ssn],
    );
    return result.isNotEmpty;
  }

  Future<int> countProductCart(String ssn, int numberProduct) async {
    final db = await database;
    final result = await db.query(
      'productCart',
      where: 'numberProduct = ? AND userSsn = ?',
      whereArgs: [numberProduct, ssn],
    );

    return result.isNotEmpty ? result[0]['count'] as int : 0;
  }

  Future<void> updateCart(int numberProduct, String ssn, int count) async {
    final db = await database;
    await db.update(
      'productCart',
      {'count': count},
      where: 'numberProduct = ? AND userSsn = ?',
      whereArgs: [numberProduct, ssn],
    );

  }

  Future<void> deleteAllCart(String ssn) async {
    final db = await database;
    await db.delete('productCart', where: 'userSsn = ?', whereArgs: [ssn]);
  }

}