

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../log_data.dart/logger_data.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'eyvo_offline.db');
    LoggerData.dataLog("DB Path: $dbPath/eyvo_offline.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE item_stock (
     ItemID INTEGER,
      ItemCode TEXT,
      OutLine TEXT,
      Description TEXT,
      CategoryID INTEGER,
      CategoryCode TEXT,
      Item_Type TEXT,
      IsStock INTEGER,
      Region_ID INTEGER,
      LocationID INTEGER,
      LocationCode TEXT,
      TotalStockCount REAL,
      NewStockCount REAL,
      Comments TEXT,
      UpdatedBy INTEGER,
      UpdatedOn TEXT,
      Synced INTEGER,
      PRIMARY KEY (ItemID, LocationID)
    )
  ''');

    await db.execute('''
    CREATE TABLE region_master (
      Region_ID INTEGER PRIMARY KEY,
      Region_Code TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE items_location (
      Location_ID INTEGER PRIMARY KEY,
      Location_Code TEXT
    )
  ''');
  }
}
