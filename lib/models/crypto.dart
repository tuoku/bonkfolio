import 'package:bonkfolio/models/database.dart';
import 'package:bonkfolio/models/pricepoint.dart';
import 'package:json_annotation/json_annotation.dart';

import 'asset.dart';

part 'crypto.g.dart';

@JsonSerializable()
class Crypto extends Asset {
  final String contractAddress;
  final String? thumbnail;
  final String? cgId;
  final double? inferredAmount;

  Crypto(
      {this.cgId,
      this.thumbnail,
      this.inferredAmount,
      required double amount,
      required double amountBought,
      required String name,
      required double price,
      required String id,
      required double avgBuyPrice,
      required this.contractAddress,
      required List<PricePoint>? chart,
      required bool isSupported})
      : super(
            amount: amount,
            amountBought: amountBought,
            avgBuyPrice: avgBuyPrice,
            price: price,
            id: id,
            name: name,
            chart: chart,
            isSupported: isSupported);

  @override
  Map<String, dynamic> toJson() => _$CryptoToJson(this);
  @override
  Crypto fromJson(json) => _$CryptoFromJson(json);

  factory Crypto.fromDb(dbCrypto e) => Crypto(
      amount: e.amount,
      amountBought: e.amountBought,
      name: e.name,
      price: e.price,
      id: e.id,
      avgBuyPrice: e.avgBuyPrice,
      contractAddress: e.contractAddress,
      chart: e.chart,
      isSupported: e.isSupported,
      thumbnail: e.thumbnail,
      cgId: e.cgId);
}
