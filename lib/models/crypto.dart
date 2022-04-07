import 'package:bonkfolio/models/pricepoint.dart';

import 'asset.dart';

class Crypto extends Asset {
  final String contractAddress;

  Crypto(
      {required double inferredAmount,
      required double realAmount,
      required double amountBought,
      required String name,
      required double price,
      required String id,
      required double avgBuyPrice,
      required this.contractAddress,
      required List<PricePoint>? chart,
      required bool isSupported})
      : super(
            amount: realAmount,
            amountBought: amountBought,
            avgBuyPrice: avgBuyPrice,
            price: price,
            id: id,
            name: name,
            chart: chart,
            isSupported: isSupported);
}
