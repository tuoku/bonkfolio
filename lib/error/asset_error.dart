class AssetError {
  String get message => "Something went wrong";
}

class CoinGeckoRateLimitReached extends AssetError {
  @override
  String get message => "CoinGecko ratelimit reached, try again later.";
}

class XScanRateLimitReached extends AssetError {
  @override
  String get message => "XScan ratelimit reached, try again later.";
}

