import 'package:http/http.dart' as http;

import 'dart:convert';

class BonkAPIRepo {
  static final BonkAPIRepo _bonkAPIRepo = BonkAPIRepo._internal();

  factory BonkAPIRepo() {
    return _bonkAPIRepo;
  }

  BonkAPIRepo._internal();

  static const _bonkApiBaseUrl = "https://bonkapi.herokuapp.com";

  Future<Map<String, BigInt>> getTokenBalances(
      List<String> contractAddresses, String holderAddress) async {
    try {
      for (var e in contractAddresses) {
        e.toLowerCase();
      }
      String contracts = contractAddresses.join(',');
      Map<String, BigInt> map = {};
      http.Response res = await http.get(Uri.parse(
          "$_bonkApiBaseUrl/tokens/balances/$contracts/$holderAddress"));
      final json = jsonDecode(res.body) as List<dynamic>;
      for (var e in json) {
        map[(e["contract"] ?? "")] = BigInt.parse((e["balance"] ?? "0")); // change type to BigInt
      }
      return map;
    } catch (e) {
      Map<String, BigInt> map = {};
      map[contractAddresses[0]] = BigInt.zero;
      return map;
    }
  }
}
