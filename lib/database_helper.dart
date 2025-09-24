import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'moony.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            date INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE budgets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT NOT NULL,
            limitAmount REAL NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE savings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            goal TEXT NOT NULL,
            amount REAL NOT NULL
          )
        ''');
      },
    );
  }

  // ===== CRUD for Transactions =====
  Future<int> insertTransaction(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('transactions', row);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return await db.query('transactions', orderBy: "date DESC");
  }

  // ===== CRUD for Budgets =====
  Future<int> insertBudget(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('budgets', row);
  }

  Future<List<Map<String, dynamic>>> getBudgets() async {
    final db = await database;
    return await db.query('budgets');
  }

  // ===== CRUD for Savings =====
  Future<int> insertSaving(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('savings', row);
  }

  Future<List<Map<String, dynamic>>> getSavings() async {
    final db = await database;
    return await db.query('savings');
  }
}
