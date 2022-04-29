// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Crypto _$CryptoFromJson(Map<String, dynamic> json) => Crypto(
      cgId: json['cgId'] as String?,
      thumbnail: json['thumbnail'] as String?,
      inferredAmount: (json['inferredAmount'] as num?)?.toDouble(),
      amount: (json['amount'] as num).toDouble(),
      amountBought: (json['amountBought'] as num).toDouble(),
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      id: json['id'] as String,
      avgBuyPrice: (json['avgBuyPrice'] as num).toDouble(),
      contractAddress: json['contractAddress'] as String,
      chart: const ChartConverter()
          .fromJson(json['chart'] as List<Map<String, dynamic>>),
      isSupported: json['isSupported'] as bool,
    );

Map<String, dynamic> _$CryptoToJson(Crypto instance) => <String, dynamic>{
      'amountBought': instance.amountBought,
      'amount': instance.amount,
      'name': instance.name,
      'price': instance.price,
      'id': instance.id,
      'avgBuyPrice': instance.avgBuyPrice,
      'chart': const ChartConverter().toJson(instance.chart),
      'isSupported': instance.isSupported,
      'contractAddress': instance.contractAddress,
      'thumbnail': instance.thumbnail,
      'cgId': instance.cgId,
      'inferredAmount': instance.inferredAmount,
    };
