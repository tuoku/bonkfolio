import 'package:http/http.dart' as http;

import 'dart:convert';

class BonkAPIRepo {
  static final BonkAPIRepo _bonkAPIRepo = BonkAPIRepo._internal();

  factory BonkAPIRepo() {
    return _bonkAPIRepo;
  }

  BonkAPIRepo._internal();

  static const _bonkApiBaseUrl = "https://bonkapi.herokuapp.com";

  Future<Map<String, BigInt>> getTokenBalances(String platform,
      List<String> contractAddresses, String holderAddress) async {
    if (contractAddresses.isEmpty ||
        holderAddress.isEmpty ||
        platform.isEmpty) {
      Map<String, BigInt> map = {};
      map[""] = BigInt.zero;
      return map;
    }
    try {
      for (var e in contractAddresses) {
        e.toLowerCase();
      }
      String contracts = contractAddresses.join(',');
      Map<String, BigInt> map = {};
      http.Response res = await http.get(Uri.parse(
          "$_bonkApiBaseUrl/tokens/$platform/balances/$contracts/$holderAddress"));
      final json = jsonDecode(res.body) as List<dynamic>;
      for (var e in json) {
        map[(e["contract"] ?? "")] =
            BigInt.parse((e["balance"] ?? "0")); // change type to BigInt
      }
      return map;
    } catch (e) {
      Map<String, BigInt> map = {};
      map[contractAddresses[0]] = BigInt.zero;
      return map;
    }
  }
}
