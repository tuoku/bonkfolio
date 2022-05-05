import 'package:bonkfolio/cache/asset_cache.dart';
import 'package:bonkfolio/services/asset_service.dart';

import '../models/asset.dart';
import '../models/crypto.dart';
import '../models/wallet.dart';
import '../services/database_service.dart';

class AssetRepository {
  AssetRepository({required this.assetService, required this.assetCache, required this.databaseService});

  final AssetService assetService;
  final AssetCache assetCache;
  final DatabaseService databaseService;

  Future<List<Asset>> getAssets(
      {required List<Wallet> wallets, bool sort = true}) async {
    List<Asset> assets = [];
    assetCache.set(await databaseService.getCryptos());
    if (assetCache.isEmpty()) {
      assets = await assetService.getAssets(wallets);
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
