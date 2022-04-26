// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricepoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PricePoint _$PricePointFromJson(Map<String, dynamic> json) => PricePoint(
      id: json['id'] as String,
      time: DateTime.parse(json['time'] as String),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$PricePointToJson(PricePoint instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'price': instance.price,
      'id': instance.id,
    };
