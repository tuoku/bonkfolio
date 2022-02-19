import 'package:mycryptos/models/pricepoint.dart';

class Asset {
  double amountBought;
  double amount;
  String name;
  double price;
  String id;
  double avgBuyPrice;
  List<PricePoint>? chart;
  bool isSupported;

  Asset(
      {required this.amount,
      required this.amountBought,
      required this.name,
      required this.price,
      required this.id,
      required this.avgBuyPrice,
      required this.chart,
      required this.isSupported});
}
