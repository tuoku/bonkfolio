import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:bonkfolio/models/crypto.dart';
import 'package:bonkfolio/models/crypto_tx.dart';
import 'package:bonkfolio/models/pricepoint.dart';
import 'package:bonkfolio/repositories/bonkapi_repo.dart';
import 'package:bonkfolio/repositories/coingecko_repo.dart';
import 'package:bonkfolio/repositories/database_repo.dart';

class XScanRepo {
  static final XScanRepo _bscScanRepo = XScanRepo._internal();

  factory XScanRepo() {
    return _bscScanRepo;
  }

  XScanRepo._internal();

  final _bscScanApiKey = dotenv.env['BSCSCAN_API_KEY'] ?? "";
  final _etherScanApiKey = dotenv.env['ETHERSCAN_API_KEY'] ?? "";
  final _snowTraceApiKey = dotenv.env['SNOWTRACE_API_KEY'] ?? "";

  static const _bscScanBaseUrl = 'https://api.bscscan.com/api';
  static const _etherScanBaseUrl = "https://api.etherscan.io/api";
  static const _snowTraceBaseUrl = 'https://api.snowtrace.io/api';

  List<CryptoTX> txCache = [];
  List<String> ignoredContracts = [];
  Map<String, BigInt> balanceCache = {};

  bool isBuilding = false;
  bool balancesFetching = false;

  static const ms = Duration(milliseconds: 1);

/*
  // for bep20 tokens
  Future<double> getTokenBalance(
      String address, String contractAddress, int decimals) async {
    http.Response res = await http.get(Uri.parse(
        ('$_baseUrl?module=account&action=tokenbalance&contractaddress=$contractAddress&address=$address&tag=latest&apikey=$_apiKey')
            .replaceAll(' ', '')));
    print(res.statusCode);
    var d = double.parse(jsonDecode(res.body)['result']);

    return d / pow(10.0, decimals);
  }
*/
  Future<List<CryptoTX>?> getTXs(String address) async {
    List<CryptoTX> allTXs = [];
    List<Future> toFetch = [];
    final wallets = await DatabaseRepo().getWallets();
    final addresses = wallets.map((e) => e.address.toLowerCase());

    for (var url in [_bscScanBaseUrl, _etherScanBaseUrl, _snowTraceBaseUrl]) {
      var apiKey = "";
      switch (url) {
        case _bscScanBaseUrl:
          apiKey = _bscScanApiKey;
          break;
        case _etherScanBaseUrl:
          apiKey = _etherScanApiKey;
          break;
        case _snowTraceBaseUrl:
          apiKey = _snowTraceApiKey;
          break;
        default:
          _bscScanBaseUrl;
      }

      toFetch.add(http.get(Uri.parse(
          '$url?module=account&action=tokentx&address=$address&startblock=0&endblock=999999999&sort=asc&apikey=$apiKey')));
    }

    final fetchedTXs = await Future.wait(toFetch);

    for (var i = 0; i <= fetchedTXs.length - 1; i++) {
      final res = fetchedTXs[i] as http.Response;
      var platform = "";
      if (res.request!.url.toString().contains(_bscScanBaseUrl)) {
        platform = "binance-smart-chain";
      }
      if (res.request!.url.toString().contains(_etherScanBaseUrl)) {
        platform = "ethereum";
      }
      if (res.request!.url.toString().contains(_snowTraceBaseUrl)) {
        platform = "avalanche";
      }

      final txs = jsonDecode(res.body)['result'];
      for (var ii = 0; ii <= txs.length - 1; ii++) {
        try {
          var a = CryptoTX(
              amount: (double.parse(txs[ii]['value'])) /
                  pow(10.0, int.parse(txs[ii]['tokenDecimal'])),
              time: DateTime.fromMillisecondsSinceEpoch(
                  int.parse(txs[ii]['timeStamp']) * 1000),
              name: txs[ii]['tokenName'],
              id: txs[ii]['tokenSymbol'],
              action: (addresses.contains(txs[ii]['to']) ? "BUY" : "SELL"),
              contractAddress: txs[ii]['contractAddress'],
              decimals: int.parse(txs[ii]['tokenDecimal']),
              clientAddress: address,
              platform: platform);
          allTXs.add(a);
        } catch (e) {
          if (kDebugMode) print(e);
        }
      }
    }

    if (allTXs.isEmpty) return null;
    return allTXs;
  }

  Future<List<CryptoTX>?> getBNBTXs(String address) async {
    http.Response res = await http.get(Uri.parse(
        '$_bscScanBaseUrl?module=account&action=txlist&address=$address&startblock=0&endblock=999999999&sort=asc&apikey=$_bscScanApiKey'));
    if (kDebugMode) print(res.statusCode);
    try {
      final txs = jsonDecode(res.body)['result'] as List<dynamic>;
      List<CryptoTX> ls = [];
      final wallets = await DatabaseRepo().getWallets();
      final addresses = wallets.map((e) => e.address.toLowerCase());
      for (var i = 0; i <= txs.length - 1; i++) {
        if (txs[i]['isError'] == "0") {
          var a = CryptoTX(
              amount: (double.parse(txs[i]['value'])) / pow(10.0, 18),
              time: DateTime.fromMillisecondsSinceEpoch(
                  int.parse(txs[i]['timeStamp']) * 1000),
              name: "Binance Coin",
              id: "BNB",
              action: (addresses.contains(txs[i]['to']) ? "BUY" : "SELL"),
              contractAddress: "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c",
              decimals: 18,
              clientAddress: address,
              platform: "binance-smart-chain");
          ls.add(a);
        }
      }

      if (ls.isEmpty) {
        return null;
      } else {
        return ls;
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    return null;
  }

  /// Returns a list of crypto assets found in wallet [addresses].
  Future<List<Crypto>> getAssets(List<String> addresses) async {
    final futures = <Future>[];
    for (var address in addresses) {
      futures.add(getTXs(address.toLowerCase()));
      // futures.add(getBNBTXs(address.toLowerCase()));
    }

    final fetched = await Future.wait(futures);
    List<CryptoTX> resolved = [];
    for (var result in fetched) {
      resolved.addAll(result ?? []);
    }
    txCache = resolved;

    if (kDebugMode) print("TOTAL TXS FOUND: " + txCache.length.toString());

    final List<Crypto> assets = [];
    final List<CryptoTX> toBuild = [];
    for (var tx in resolved) {
      while (isBuilding) {
        await Future.delayed(ms);
      }
      if (toBuild
              .where((e) => e.contractAddress == tx.contractAddress)
              .isEmpty &&
          !ignoredContracts.contains(tx.contractAddress.toLowerCase())) {
        toBuild.add(tx);
      }
    }
    final List<Future> fs = [];
    final List<String> bscBalancesToGet = [];
    final List<String> ethBalancesToGet = [];
    final List<String> avaxBalancesToGet = [];
    //balanceCache.clear();

    for (var t in toBuild) {
      switch (t.platform) {
        case "binance-smart-chain":
          bscBalancesToGet.add(t.contractAddress);
          break;
        case "ethereum":
          ethBalancesToGet.add(t.contractAddress);
          break;
        case "avalanche":
          avaxBalancesToGet.add(t.contractAddress);
          break;
        default:
          bscBalancesToGet.add(t.contractAddress);
          break;
      }
    }

    final List<Future> balanceFs = [];
    balanceFs.add(
        getRealBalances("binance-smart-chain", bscBalancesToGet, addresses[0]));
    balanceFs.add(getRealBalances("ethereum", ethBalancesToGet, addresses[0]));
    balanceFs
        .add(getRealBalances("avalanche", avaxBalancesToGet, addresses[0]));

    final balances = await Future.wait(balanceFs);
    for (var f in balances) {
      balanceCache.addAll(f);
    }

    for (var t in toBuild) {
      fs.add(constructCrypto(t));
    }

    while (balancesFetching) {
      await Future.delayed(ms);
    }

    final built = await Future.wait(fs);

    for (var b in built) {
      if (b != null) assets.add(b);
    }

    while (isBuilding) {
      await Future.delayed(ms);
    }

    return assets;
  }

  Future<Map<String, BigInt>> getRealBalances(
      platform, contracts, holder) async {
    balancesFetching = true;
    final val =
        await BonkAPIRepo().getTokenBalances(platform, contracts, holder);
    balancesFetching = false;
    return val;
  }

  Future<Crypto?> constructCrypto(CryptoTX tx) async {
    while (balancesFetching) {
      await Future.delayed(ms);
    }
    isBuilding = true;
    final start = DateTime.now().millisecondsSinceEpoch;

    final txs = txCache
        .where((txx) => tx.contractAddress == txx.contractAddress)
        .toList();
    final amount = txs.fold(
        0.0,
        (pv, tx) =>
            (pv as double) + (tx.action == "BUY" ? tx.amount : tx.amount * -1));
    if (((balanceCache[tx.contractAddress.toLowerCase()] ?? BigInt.one) /
                BigInt.from((pow(10.0, tx.decimals)))) >
            0.0 ||
        tx.id == "BNB") {
      final txss = txs;
      txss.sort((a, b) => a.time.compareTo(b.time));
      final daysSinceFirstTx =
          DateTime.now().difference(txss.first.time).inDays;
      final charts = await CoinGeckoRepo().getChartsByContract(
          tx.contractAddress, tx.platform, daysSinceFirstTx + 1);
      if (charts != null) {
        await CoinGeckoRepo()
            .getInfosByContract(tx.contractAddress, tx.platform);
      }

      final avg = await _avgBuyPrice(txs, charts);
      isBuilding = false;
      final end = DateTime.now().millisecondsSinceEpoch;
      if (kDebugMode) print("Built ${tx.name} in ${end - start}ms");
      return Crypto(
          amountBought: tx.amount,
          inferredAmount: amount,
          realAmount:
              ((balanceCache[tx.contractAddress.toLowerCase()] ?? BigInt.one) /
                  BigInt.from((pow(10.0, tx.decimals)))),
          price: charts?.last.price ?? 0,
          name: tx.name,
          id: tx.id,
          avgBuyPrice: avg,
          contractAddress: tx.contractAddress,
          chart: charts,
          isSupported: charts != null);
    } else {
      ignoredContracts.add(tx.contractAddress.toLowerCase());
      // clear ignoreds sometime??
      isBuilding = false;
      return null;
    }
  }

/*
// for bep20 tokens
  Future<double> getBuyAmount(
      String address, String contractAddress, int decimals) async {
    http.Response res = await http.get(Uri.parse(
        ('$_baseUrl?module=account&action=tokentx&contractaddress=$contractAddress&address=$address&page=1&offset=5&startblock=0&endblock=999999999&sort=asc&apikey=$_apiKey')
            .replaceAll(' ', '')));
    final r = double.parse((jsonDecode(res.body)['result'][0])['value']);
    return r / pow(10.0, decimals);
  }
*/
  Future<double> getBNBBalance(String address) async {
    http.Response res = await http.get(Uri.parse(
        '$_bscScanBaseUrl?module=account&action=balance&address=$address&apikey=$_bscScanApiKey'));
    final r = int.parse(jsonDecode(res.body)['result']);
    return r * 18.0;
  }

  Future<double> _avgBuyPrice(
      List<CryptoTX> txs, List<PricePoint>? chart) async {
    if (chart == null) return 0.0;
    final start = DateTime.now().millisecondsSinceEpoch;
    List<double> buyPrices = [];
    List<double> weights = [];
    // fix: only buys
    final buys = txs.where((tx) => tx.action == "BUY").toList();
    List<Future<double>> buyFutures = [];
    for (var tx in buys) {
      Map map = {};
      map['time'] = tx.time;
      map['chart'] = chart;
      buyFutures.add(compute(findBuyPrice, map));
    }

    List<double> fbs = await Future.wait(buyFutures);
    buyPrices.addAll(fbs);

    final totalBought = txs.fold(
        0.0, (pv, tx) => (pv as double) + (tx.action == "BUY" ? tx.amount : 0));

    for (var buy in buys) {
      weights.add(buy.amount / totalBought);
    }
    List<double> multiplied = [];
    for (var i = 0; i <= buys.length - 1; i++) {
      multiplied.add(buyPrices[i] * weights[i]);
    }

    final total = multiplied.fold(0.0, (pv, n) => (pv as double) + n);
    final end = DateTime.now().millisecondsSinceEpoch;
    if (kDebugMode) print("avgBuyPrice took ${end - start}ms");
    return total;
  }
}

Future<double> findBuyPrice(map) async {
  final time = map['time'];
  final chart = map['chart'];
  if (chart != null) {
    return chart
        .firstWhere((e) =>
            e.time.millisecondsSinceEpoch.toDouble() ==
            (chart.fold(
                chart[0].time.millisecondsSinceEpoch.toDouble(),
                (previousValue, element) =>
                    (element.time.millisecondsSinceEpoch.toDouble() -
                                    time.millisecondsSinceEpoch.toDouble())
                                .abs() <
                            ((previousValue as double) -
                                    time.millisecondsSinceEpoch.toDouble())
                                .abs()
                        ? element.time.millisecondsSinceEpoch.toDouble()
                        : previousValue)))
        .price;
  } else {
    return 0;
  }
}
