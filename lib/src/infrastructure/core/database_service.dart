import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

@lazySingleton
class DatabaseServices {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      print("Returning existing database instance.");
      return _db!;
    }

    _db = await initDB();
    print("Database initialized: $_db");
    return _db!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'service_booking.db');
    print("Initializing path... $path");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        print("Database upgraded from version $oldVersion to $newVersion");
        // Add upgrade logic here if needed in future
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  FutureOr<void> _createDB(db, version) async {
    print("Creating database tables...");
    await db.execute('''
       CREATE TABLE providers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        category TEXT,
        location TEXT,
        contact TEXT
      )
    ''');

    print('Table "providers" created successfully.');
    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        provider_id INTEGER,
        date TEXT,
        time TEXT,
        note TEXT,
        FOREIGN KEY(provider_id) REFERENCES providers(id)
      )
    ''');
    print('Table "bookings" created successfully.');
  }

  // // Table: providers
  // await _createTable(
  //   database: db,
  //   tableName: 'providers',
  //   query: '''
  //   CREATE TABLE providers (
  //     id INTEGER PRIMARY KEY AUTOINCREMENT,
  //     name TEXT,
  //     category TEXT,
  //     location TEXT,
  //     contact TEXT
  //   )
  // ''',
  // );

  // // Table: bookings
  // await _createTable(
  //   database: db,
  //   tableName: 'bookings',
  //   query: '''
  //   CREATE TABLE bookings (
  //     id INTEGER PRIMARY KEY AUTOINCREMENT,
  //     provider_id INTEGER,
  //     date TEXT,
  //     time TEXT,
  //     note TEXT,
  //     FOREIGN KEY(provider_id) REFERENCES providers(id)
  //   )
  // ''',
  // );

  // Future<void> _createTable({
  //   required Database database,
  //   required String tableName,
  //   required String query,
  // }) async {
  //   print("Creating table: $tableName...");
  //   try {
  //     await database.execute(query);
  //     print('Table "$tableName" created successfully.');
  //   } catch (e) {
  //     print('Error creating table "$tableName": $e');
  //   }
  // }

  Future<int> insertData({
    required String tableName,
    required Map<String, Object?> data,
  }) async {
    final db = await database;
    return await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getData({
    required String tableName,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    print("Fetching data from table: $tableName");
    return await db.query(tableName, where: where, whereArgs: whereArgs);
  }

  Future<int> updateData({
    required String tableName,
    required Map<String, Object?> data,
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await database;
    return await db.update(tableName, data, where: where, whereArgs: whereArgs);
  }

  Future<int> deleteData({
    required String tableName,
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await database;
    return await db.delete(tableName, where: where, whereArgs: whereArgs);
  }
}
