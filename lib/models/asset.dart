import 'package:bonkfolio/models/pricepoint.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset.g.dart';

class ChartConverter
    implements JsonConverter<List<PricePoint>?, List<Map<String, dynamic>>> {
  const ChartConverter();

  @override
  List<PricePoint>? fromJson(List<Map<String, dynamic>> json) {
    if (json == null) {
      return null;
    }

    return List.generate(
        json.length,
        (i) => PricePoint(
            id: json[i]['id'],
            time: DateTime.parse(json[i]['time']),
            price: json[i]['price']));
  }

  @override
  List<Map<String, dynamic>> toJson(List<PricePoint>? object) {
    if (object == null) {
      return [];
    }

    return List.generate(
        object.length,
        (i) => {
              'id': object[i].id,
              'time': object[i].time.toIso8601String(),
              'price': object[i].price
            });
  }
}

@JsonSerializable()
class Asset {
  double amountBought;
  double amount;
  String name;
  double price;
  String id;
  double avgBuyPrice;
  @ChartConverter()
  List<PricePoint>? chart;
  bool isSupported;

  Map<String, dynamic> toJson() => _$AssetToJson(this);
  Asset fromJson(json) => _$AssetFromJson(json);

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
