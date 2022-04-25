import 'package:bonkfolio/services/asset_service.dart';

import '../models/asset.dart';
import '../models/database.dart';

class AssetRepository {
  AssetRepository({required this.assetService});

  final AssetService assetService;

  Future<List<Asset>> getAssets({required List<Wallet> wallets, bool sort = true}) async {
    final assets = await assetService.getAssets(wallets);
    if(sort) assets.sort((a, b) => (b.amount * b.price).compareTo((a.amount * a.price)));
    return assets;
  }
}