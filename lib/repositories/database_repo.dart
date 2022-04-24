import 'package:bonkfolio/models/database.dart';
import 'package:bonkfolio/models/database/shared.dart' as shared;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
//import 'package:bonkfolio/models/wallet.dart';

class DatabaseRepo {
  static final DatabaseRepo _databaseRepo = DatabaseRepo._internal();

  factory DatabaseRepo() {
    return _databaseRepo;
  }

  DatabaseRepo._internal();

  Database? _db;
  Future<Database> get db async =>
      _db ??= await shared.constructDb(logStatements: kDebugMode);

  List<Wallet> walletCache = [];

  Future<void> init() async {
   //db = await shared.constructDb(logStatements: kDebugMode);
  }

  Future<void> insertWallet(Wallet wallet) async {
    await (await db).createWallet(WalletsCompanion(
        id: Value(wallet.id),
        address: Value(wallet.address),
        name: Value(wallet.name)));
  }

  Future<List<Wallet>> getWallets() async {
    return await (await db).getWallets();
  }

  Future<void> deleteWallet(String address) async {
    await (await db).deleteWallet(walletCache.where((element) => element.address == address).first);
  }
}
