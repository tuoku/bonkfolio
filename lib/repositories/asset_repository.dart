import 'package:bonkfolio/services/asset_service.dart';

import '../models/asset.dart';
import '../models/wallet.dart';

class AssetRepository {
  AssetRepository({required this.assetService});

  final AssetService assetService;

  Future<List<Asset>> getAssets(
      {required List<Wallet> wallets, bool sort = true}) async {
    final assets = await assetService.getAssets(wallets);
    if (sort)
      assets
          .sort((a, b) => (b.amount * b.price).compareTo((a.amount * a.price)));
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
