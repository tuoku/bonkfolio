class AssetError {
  String get message => "Something went wrong";
}

class CoinGeckoRateLimitReached extends AssetError {
  @override
  String get message => "CoinGecko ratelimit reached, try again later.";
}

class CoinGeckoNotFound extends AssetError {
  CoinGeckoNotFound({required this.contractAddress});
  final String contractAddress;
  @override
  String get message => "Asset $contractAddress not found";
}

class XScanRateLimitReached extends AssetError {
  @override
  String get message => "XScan ratelimit reached, try again later.";
}

