import 'package:bonkfolio/cache/asset_cache.dart';
import 'package:bonkfolio/cache/crypto_tx_cache.dart';
import 'package:bonkfolio/models/crypto_tx.dart';
import 'package:bonkfolio/services/asset_service.dart';

import '../models/asset.dart';
import '../models/crypto.dart';
import '../models/wallet.dart';
import '../services/database_service.dart';

class AssetRepository {
  AssetRepository(
      {required this.assetService,
      required this.assetCache,
      required this.databaseService,
      required this.transactionCache});

  final AssetService assetService;
  final AssetCache assetCache;
  final DatabaseService databaseService;
  final CryptoTXCache transactionCache;

  Future<List<Asset>> getAssets(
      {required List<Wallet> wallets, bool sort = true}) async {
    List<Asset> assets = [];
    List<CryptoTX> transactions = [];

    assetCache.set(await databaseService.getCryptos());
    transactionCache.set(await databaseService.getTransactions());

    if (transactionCache.isEmpty()) {
      final futures = <Future>[];
      for (var wallet in wallets) {
        futures.add(assetService.getTXs(wallet.address.toLowerCase(), wallets));
      }

      final fetched = await Future.wait(futures);
      List<CryptoTX> resolved = [];
      for (var result in fetched) {
        resolved.addAll(result ?? []);
      }

      transactions = resolved;
      transactionCache.set(resolved);
      databaseService.insertTransactions(resolved);
    } else {
      transactions = transactionCache.get();
    }

    if (assetCache.isEmpty()) {
      assets = await assetService.getAssets(wallets, transactions);
      assetCache.set(assets);
      databaseService.insertCryptos(assets as List<Crypto>);
    } else {
      assets = assetCache.get();
    }

    if (sort) {
      assets
          .sort((a, b) => (b.amount * b.price).compareTo((a.amount * a.price)));
    }
    return assets;
  }

  /// Takes a list of assets and returns the list with updated price and amount information
  Future<List<Asset>> refreshAssets(List<Asset> toRefresh) async {
    return await assetService.refreshAssets(toRefresh);
  }

  double getPortfolioValue(List<Asset> assets) {
    return assetService.getPortfolioValue(assets);
  }
}
