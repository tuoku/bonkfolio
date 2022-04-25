import 'package:bonkfolio/services/asset_service.dart';

import '../models/asset.dart';
import '../models/database.dart';

class AssetRepository {
  AssetRepository({required this.assetService});

  final AssetService assetService;

  Future<List<Asset>> getAssets(List<Wallet> wallets) async {
    final assets = await assetService.getAssets(wallets);
    return assets;
  }
}