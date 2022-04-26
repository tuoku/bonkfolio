// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      amount: (json['amount'] as num).toDouble(),
      amountBought: (json['amountBought'] as num).toDouble(),
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      id: json['id'] as String,
      avgBuyPrice: (json['avgBuyPrice'] as num).toDouble(),
      chart: const ChartConverter()
          .fromJson(json['chart'] as List<Map<String, dynamic>>),
      isSupported: json['isSupported'] as bool,
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'amountBought': instance.amountBought,
      'amount': instance.amount,
      'name': instance.name,
      'price': instance.price,
      'id': instance.id,
      'avgBuyPrice': instance.avgBuyPrice,
      'chart': const ChartConverter().toJson(instance.chart),
      'isSupported': instance.isSupported,
    };
