import 'package:bonkfolio/models/database.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crypto_tx.g.dart';

@JsonSerializable()
class CryptoTX {
  DateTime time;
  double amount;
  String name;
  String id;
  String action;
  String contractAddress;
  int decimals;
  String clientAddress;
  String platform;

  CryptoTX(
      {required this.action,
      required this.amount,
      required this.id,
      required this.name,
      required this.time,
      required this.contractAddress,
      required this.decimals,
      required this.clientAddress,
      required this.platform});

  Map<String, dynamic> toJson() => _$CryptoTXToJson(this);
  CryptoTX fromJson(json) => _$CryptoTXFromJson(json);

  factory CryptoTX.fromDb(dbCryptoTX e) => CryptoTX(
      action: e.action,
      amount: e.amount,
      id: e.id,
      name: e.name,
      time: e.time,
      contractAddress: e.contractAddress,
      decimals: e.decimals,
      clientAddress: e.clientAddress,
      platform: e.platform);
}
