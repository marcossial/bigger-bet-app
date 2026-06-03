import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'biggerbet.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        balance REAL NOT NULL DEFAULT 1000.00
      )
    ''');
  }

  Future<int> createUser(String name, String email, String password) async {
    final db = await database;
    try {
      return await db.insert('users', {
        'name': name,
        'email': email,
        'password': password,
        'balance': 1000.00, // Initial balance
      });
    } catch (e) {
      // E.g., unique constraint violation (email already exists)
      return -1;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<double> getUserBalance(int userId) async {
    final db = await database;
    final results = await db.query(
      'users',
      columns: ['balance'],
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return (results.first['balance'] as num).toDouble();
    }
    return 0.0;
  }

  Future<void> updateBalance(int userId, double newBalance) async {
    final db = await database;
    await db.update(
      'users',
      {'balance': newBalance},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
