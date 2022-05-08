// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_tx.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptoTX _$CryptoTXFromJson(Map<String, dynamic> json) => CryptoTX(
      action: json['action'] as String,
      amount: (json['amount'] as num).toDouble(),
      id: json['id'] as String,
      name: json['name'] as String,
      time: DateTime.parse(json['time'] as String),
      contractAddress: json['contractAddress'] as String,
      decimals: json['decimals'] as int,
      clientAddress: json['clientAddress'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$CryptoTXToJson(CryptoTX instance) => <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'amount': instance.amount,
      'name': instance.name,
      'id': instance.id,
      'action': instance.action,
      'contractAddress': instance.contractAddress,
      'decimals': instance.decimals,
      'clientAddress': instance.clientAddress,
      'platform': instance.platform,
    };
