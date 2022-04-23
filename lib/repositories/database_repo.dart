import 'package:bonkfolio/models/database.dart';
import 'package:bonkfolio/models/database/shared.dart' as shared;
import 'package:drift/drift.dart';
//import 'package:bonkfolio/models/wallet.dart';

class DatabaseRepo {
  static final DatabaseRepo _databaseRepo = DatabaseRepo._internal();

  factory DatabaseRepo() {
    return _databaseRepo;
  }

  DatabaseRepo._internal();

  final Database db = shared.constructDb();
  List<Wallet> walletCache = [];

  Future<void> init() async {
    /*
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
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
          'CREATE TABLE wallets(address TEXT, name TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    */
  }

  Future<void> insertWallet(Wallet wallet) async {
    await db.createWallet(WalletsCompanion(
        id: Value(wallet.id),
        address: Value(wallet.address),
        name: Value(wallet.name)));
  }

  Future<List<Wallet>> getWallets() async {
    return await db.getWallets();
  }

  Future<void> deleteWallet(String address) async {
    await db.deleteWallet(walletCache.where((element) => element.address == address).first);
  }
}
