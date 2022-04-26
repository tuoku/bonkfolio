import 'package:json_annotation/json_annotation.dart';

part 'pricepoint.g.dart';

@JsonSerializable()
class PricePoint {
  final DateTime time;
  final double price;
  final String id;

  PricePoint({required this.id, required this.time, required this.price});

  static PricePoint fromJson(Map<String, dynamic> e) => _$PricePointFromJson(e);
  static Map<String,dynamic> toJson(PricePoint e) => _$PricePointToJson(e);
  

}
