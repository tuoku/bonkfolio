import 'package:drift/drift.dart';
import 'package:undo/undo.dart';

import 'database/db_utils.dart';

export 'database/shared.dart';

part 'database.g.dart';

class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get address => text()();

  TextColumn get name => text()();
}

@DriftDatabase(tables: [Wallets])
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);
  final cs = ChangeStack();

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
      beforeOpen: (details) async {},
    );
  }

  Stream<List<Wallet>> watchWallets() {
    return (select(wallets)).watch();
  }

  Future<List<Wallet>> getWallets() {
    return (select(wallets)).get();
  }

  Future<void> createWallet(WalletsCompanion entry) async {
    await into(wallets).insert(entry);
  }

  /// Updates the row in the database represents this entry by writing the
  /// updated data.
  Future updateWallet(Wallet entry) async {
    return updateRow(cs, wallets, entry);
  }

  Future deleteWallet(Wallet entry) {
    return deleteRow(cs, wallets, entry);
  }
}
