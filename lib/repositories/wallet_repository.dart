import 'package:bonkfolio/services/database_service.dart';

import '../models/database.dart';

class WalletRepository {
  WalletRepository({required this.databaseService});
  final DatabaseService databaseService;

  Future<List<Wallet>> getWallets() async {
    return await databaseService.getWallets();
  }

  Future<void> addWallet(Wallet wallet) async {
    await databaseService.insertWallet(wallet);
  }
}
