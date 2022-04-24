import 'package:bonkfolio/repositories/xscan_repo.dart';
import 'package:bonkfolio/services/xscan_service.dart';

import '../models/asset.dart';
import '../models/database.dart';

class AssetRepository {
  AssetRepository({required this.xScanService});

  final XScanService xScanService;

  Future<List<Asset>> getAssets(List<Wallet> wallets) async {
    final assets = await xScanService.getAssets(wallets.map((e) => e.address).toList());
    return assets;
  }
}