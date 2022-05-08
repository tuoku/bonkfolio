import 'package:bonkfolio/models/crypto_tx.dart';

class CryptoTXCache {
  List<CryptoTX> _cache = [];

  List<CryptoTX> get() => _cache;

  void clear() => _cache.clear();

  bool isEmpty() => _cache.isEmpty;

  void set(List<CryptoTX> assets) => _cache = assets;
}