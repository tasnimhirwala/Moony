// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pursenal.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Transactions
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL,
            date INTEGER
          )
        ''');

        // Budgets
        await db.execute('''
          CREATE TABLE budgets(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT,
            limitAmount REAL
          )
        ''');

        // Savings
        await db.execute('''
          CREATE TABLE savings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            goal TEXT,
            amount REAL
          )
        ''');

        // Profile (only one row expected)
        await db.execute('''
          CREATE TABLE profile(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            phone TEXT
          )
        ''');
      },
    );
  }

  // ---------------- Transactions ----------------
  Future<int> insertTransaction(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('transactions', row);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return await db.query('transactions', orderBy: 'id DESC');
  }

  // ---------------- Budgets ----------------
  Future<int> insertBudget(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('budgets', row);
  }

  Future<List<Map<String, dynamic>>> getBudgets() async {
    final db = await database;
    return await db.query('budgets', orderBy: 'id DESC');
  }

  // ---------------- Savings ----------------
  Future<int> insertSaving(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('savings', row);
  }

  Future<List<Map<String, dynamic>>> getSavings() async {
    final db = await database;
    return await db.query('savings', orderBy: 'id DESC');
  }

  // ---------------- Profile ----------------
  Future<int> insertProfile(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('profile', row);
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final db = await database;
    final res = await db.query('profile', limit: 1);
    if (res.isNotEmpty) return res.first;
    return null;
  }

  Future<int> updateProfile(Map<String, dynamic> row) async {
    final db = await database;
    return await db.update(
      'profile',
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }
}
