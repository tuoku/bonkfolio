import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mycryptos/models/asset_meta.dart';
import 'package:mycryptos/models/pricepoint.dart';

class CoinGeckoRepo {
  static final CoinGeckoRepo _coinGeckoRepo = CoinGeckoRepo._internal();

  factory CoinGeckoRepo() {
    return _coinGeckoRepo;
  }

  CoinGeckoRepo._internal();

  static const _baseUrl = 'https://api.coingecko.com/api/v3';
  List<AssetMeta> metas = [];
  final Map<String, String> table = {};
/*
  Future<double> getCurrentPrice(String id) async {
    if (id == "") return 0;

    http.Response res = await http.get(Uri.parse(
        '$_baseUrl/coins/$id?localization=false&tickers=false&community_data=false&developer_data=false&sparkline=false'));
    final m = ((jsonDecode(res.body)['image'])['small']);
    if (metas
        .where((element) => element.id == id && element.thumbnail != null)
        .isEmpty) {
      metas.add(AssetMeta(id: (jsonDecode(res.body)['symbol']), thumbnail: m));
    }
    var d = 0.0;
    try {
      d = (jsonDecode(res.body)['market_data']['current_price'])['usd'];
    } catch (e) {
      print(e);
    }

    return d;
  }
*/
  Future<void> getInfosByContract(String contract, String platform) async {
    http.Response res = await http
        .get(Uri.parse('$_baseUrl/coins/$platform/contract/$contract'));
    final m = jsonDecode(res.body);

    if (metas
        .where((element) => element.id == contract && element.thumbnail != null)
        .isEmpty) {
      metas.add(AssetMeta(
          id: contract, thumbnail: m['image']['small'], cgId: m['id']));
    }
  }

  Future<Map> getPricesByIDs(List<String> ids) async {
    String ss = "";
    for (var id in ids) {
      ss += '$id,';
    }
    http.Response res = await http
        .get(Uri.parse('$_baseUrl/simple/price?ids=$ss&vs_currencies=usd'));
    final body = jsonDecode(res.body);

    Map map = {};
    for (var id in ids) {
      map[id] = body[id]['usd'];
    }
    return map;
  }

  Future<double> getPriceAt(DateTime time, String id) async {
    if (id == "") return 0;
    http.Response res = await http.get(Uri.parse(
        '$_baseUrl/coins/$id/history?date=${DateFormat('dd-MM-yyyy').format(time)}&localization=false'));
    var d = 0.0;
    try {
      d = (jsonDecode(res.body)['market_data']['current_price'])['usd'];
    } catch (e) {
      if (kDebugMode) print(e);
    }
    return d;
  }

  Future<void> refreshLookupTable() async {
    http.Response res = await http.get(Uri.parse('$_baseUrl/coins/list'));
    final body = jsonDecode(res.body);
    for (var i = 0; true; i++) {
      try {
        table[body[i]['id']] = body[i]['symbol'];
      } catch (e) {
        if (kDebugMode) print(e);
        break;
      }
    }
  }

  Future<List<PricePoint>> getCharts(String id) async {
    http.Response res = await http.get(Uri.parse(
        '$_baseUrl/coins/$id/market_chart?vs_currency=usd&days=30&interval=daily'));
    final m = jsonDecode(res.body);
    return List.generate(
        m['prices'].length,
        (index) => PricePoint(
            id: id,
            time: DateTime.fromMillisecondsSinceEpoch(m['prices'][index][0]),
            price: (m['prices'][index][1])));
  }

  Future<List<PricePoint>?> getChartsByContract(
      String contract, String platform, int days) async {
    http.Response res = await http.get(Uri.parse(
        '$_baseUrl/coins/$platform/contract/$contract/market_chart?vs_currency=usd&days=$days'));
    final m = jsonDecode(res.body);
    if (res.statusCode != 200) return null;
    return List.generate(
        m['prices'].length,
        (index) => PricePoint(
            id: contract,
            time: DateTime.fromMillisecondsSinceEpoch(m['prices'][index][0]),
            price: (m['prices'][index][1])));
  }

  String? geckoIDtoSymbol(String id) {
    return table[id];
  }

  String? symbolToGeckoID(String symbol) {
    final ls = table.entries.where((element) => element.value == symbol);
    if (ls.isEmpty) return null;
    return ls.first.key;
  }

  Future<String?> contractToGeckoID(String contract, String platform) async {
    http.Response res = await http
        .get(Uri.parse('$_baseUrl/coins/$platform/contract/$contract'));
    final m = jsonDecode(res.body);
    return m['id'];
  }

  Future<Map<String, double>> getCurrentPrices(List<String> ids) async {
    var idList = "";
    for (var id in ids) {
      if (id != ids.last) {
        idList += id + ",";
      } else {
        idList += id;
      }
    }
    http.Response res = await http
        .get(Uri.parse('$_baseUrl/simple/price?ids=$idList&vs_currencies=usd'));
    final m = jsonDecode(res.body);

    Map<String, double> map = {};
    for (var i = 0; i <= m.length - 1; i++) {
      map[m[i].key] = m[i]["usd"];
    }
    return map;
  }
}
