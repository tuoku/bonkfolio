import 'package:flutter/widgets.dart';
import 'package:mycryptos/models/wallet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseRepo {
  static final DatabaseRepo _databaseRepo = DatabaseRepo._internal();

  factory DatabaseRepo() {
    return _databaseRepo;
  }

  DatabaseRepo._internal();

  Database? database;
  List<Wallet> walletCache = [];

  Future<void> init() async {
    // Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async  {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
          'CREATE TABLE wallets(address TEXT, name TEXT)',
        );
        
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertWallet(Wallet wallet) async {
    final db = await database;

    await db?.insert(
      'wallets',
      wallet.toMap(),
      
     
    );
  }

  Future<List<Wallet>> getWallets() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db!.query('wallets');

    final ls = List.generate(maps.length, (i) {
      return Wallet(address: maps[i]['address'], name: maps[i]['name']);
    });
    walletCache = ls;
    return ls;
  }

  Future<void> deleteWallet(String address) async {
    final db = await database;

    await db?.delete(
      'wallets',
      where: 'address = ?',
      whereArgs: [address],
    );
  }
}
