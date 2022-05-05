import 'package:bonkfolio/models/asset.dart';
import 'package:bonkfolio/models/crypto.dart';
import 'package:bonkfolio/models/pricepoint.dart';
import 'package:bonkfolio/models/wallet.dart';
import 'package:drift/drift.dart';
import 'package:undo/undo.dart';

import 'database/db_utils.dart';

export 'database/shared.dart';

part 'database.g.dart';

@DataClassName('dbWallet')
class Wallets extends Table {
  TextColumn get address => text()();

  TextColumn get name => text()();

    @override
  Set<Column> get primaryKey => {address};
}

@DataClassName('dbCrypto')
class Cryptos extends Table {
  TextColumn get contractAddress => text()();
  TextColumn get thumbnail => text().nullable()();
  TextColumn get cgId => text().nullable()();
  RealColumn get inferredAmount => real().nullable()();
  RealColumn get amount => real()();
  RealColumn get amountBought => real()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get id => text()();
  RealColumn get avgBuyPrice => real()();
  TextColumn get chart => text().map(const ChartConverter())();
  BoolColumn get isSupported => boolean()();

  @override
  Set<Column> get primaryKey => {contractAddress};
}

@DriftDatabase(tables: [Wallets, Cryptos])
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);
  final cs = ChangeStack();

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (to == 2) {
          m.createTable(cryptos);
        }
      },
      beforeOpen: (details) async {},
    );
  }

  Stream<List<Wallet>> watchWallets() {
    return (select(wallets).map((p0) => Wallet.fromDb(p0))).watch();
  }

  Future<List<Wallet>> getWallets() {
    return (select(wallets).map((p0) => Wallet.fromDb(p0))).get();
  }

  Future<void> createWallet(WalletsCompanion entry) async {
    await into(wallets).insertOnConflictUpdate(entry);
  }

  /// Updates the row in the database represents this entry by writing the
  /// updated data.
  Future updateWallet(Wallet entry) async {
    return updateRow(cs, wallets, entry.toDb());
  }

  Future deleteWallet(Wallet entry) {
    return deleteRow(cs, wallets, entry.toDb());
  }

  Future<List<Crypto>> getCryptos() {
    return (select(cryptos).map((p0) => Crypto.fromDb(p0))).get();
  }

  Future insertCryptos(List<Crypto> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(
          cryptos,
          entries.map((e) => CryptosCompanion.insert(
              contractAddress: e.contractAddress,
              amount: e.amount,
              amountBought: e.amountBought,
              name: e.name,
              price: e.price,
              id: e.id,
              avgBuyPrice: e.avgBuyPrice,
              chart: e.chart,
              isSupported: e.isSupported,
              thumbnail: Value(e.thumbnail),
              cgId: Value(e.cgId))));
    });
  }
}
