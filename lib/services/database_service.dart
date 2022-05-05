import 'package:bonkfolio/models/database.dart';
import 'package:bonkfolio/models/wallet.dart';
import 'package:bonkfolio/models/database/shared.dart' as shared;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../models/crypto.dart';

class DatabaseService {
  Database? _db;
  Future<Database> get db async =>
      _db ??= await shared.constructDb(logStatements: kDebugMode);

  List<Wallet> walletCache = [];

  Future<void> init() async {
    //db = await shared.constructDb(logStatements: kDebugMode);
  }

  Future<void> insertWallet(Wallet wallet) async {
    await (await db).createWallet(WalletsCompanion(
        address: Value(wallet.address), name: Value(wallet.name)));
  }

  Future<List<Wallet>> getWallets() async {
    return await (await db).getWallets();
  }

  Future<void> deleteWallet(String address) async {
    await (await db).deleteWallet(
        walletCache.where((element) => element.address == address).first);
  }

  Future<List<Crypto>> getCryptos() async {
    return await (await db).getCryptos();
  }

  Future<void> insertCryptos(List<Crypto> cryptos) async {
    await (await db).insertCryptos(cryptos);
  }
}
