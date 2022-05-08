import 'package:bonkfolio/models/asset.dart';

class AssetCache {

  List<Asset> _cache = [];

  List<Asset> get() => _cache;

  void clear() => _cache.clear();

  bool isEmpty() => _cache.isEmpty;

  void set(List<Asset> assets) => _cache = assets;

  
}