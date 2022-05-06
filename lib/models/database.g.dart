// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class dbWallet extends DataClass implements Insertable<dbWallet> {
  final String address;
  final String name;
  dbWallet({required this.address, required this.name});
  factory dbWallet.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return dbWallet(
      address: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}address'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['address'] = Variable<String>(address);
    map['name'] = Variable<String>(name);
    return map;
  }

  WalletsCompanion toCompanion(bool nullToAbsent) {
    return WalletsCompanion(
      address: Value(address),
      name: Value(name),
    );
  }

  factory dbWallet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return dbWallet(
      address: serializer.fromJson<String>(json['address']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'address': serializer.toJson<String>(address),
      'name': serializer.toJson<String>(name),
    };
  }

  dbWallet copyWith({String? address, String? name}) => dbWallet(
        address: address ?? this.address,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('dbWallet(')
          ..write('address: $address, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(address, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is dbWallet &&
          other.address == this.address &&
          other.name == this.name);
}

class WalletsCompanion extends UpdateCompanion<dbWallet> {
  final Value<String> address;
  final Value<String> name;
  const WalletsCompanion({
    this.address = const Value.absent(),
    this.name = const Value.absent(),
  });
  WalletsCompanion.insert({
    required String address,
    required String name,
  })  : address = Value(address),
        name = Value(name);
  static Insertable<dbWallet> custom({
    Expression<String>? address,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (address != null) 'address': address,
      if (name != null) 'name': name,
    });
  }

  WalletsCompanion copyWith({Value<String>? address, Value<String>? name}) {
    return WalletsCompanion(
      address: address ?? this.address,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletsCompanion(')
          ..write('address: $address, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $WalletsTable extends Wallets with TableInfo<$WalletsTable, dbWallet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _addressMeta = const VerificationMeta('address');
  @override
  late final GeneratedColumn<String?> address = GeneratedColumn<String?>(
      'address', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [address, name];
  @override
  String get aliasedName => _alias ?? 'wallets';
  @override
  String get actualTableName => 'wallets';
  @override
  VerificationContext validateIntegrity(Insertable<dbWallet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {address};
  @override
  dbWallet map(Map<String, dynamic> data, {String? tablePrefix}) {
    return dbWallet.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $WalletsTable createAlias(String alias) {
    return $WalletsTable(attachedDatabase, alias);
  }
}

class dbCrypto extends DataClass implements Insertable<dbCrypto> {
  final String contractAddress;
  final String? thumbnail;
  final String? cgId;
  final double? inferredAmount;
  final double amount;
  final double amountBought;
  final String name;
  final double price;
  final String id;
  final double avgBuyPrice;
  final List<PricePoint>? chart;
  final bool isSupported;
  dbCrypto(
      {required this.contractAddress,
      this.thumbnail,
      this.cgId,
      this.inferredAmount,
      required this.amount,
      required this.amountBought,
      required this.name,
      required this.price,
      required this.id,
      required this.avgBuyPrice,
      required this.chart,
      required this.isSupported});
  factory dbCrypto.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return dbCrypto(
      contractAddress: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}contract_address'])!,
      thumbnail: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}thumbnail']),
      cgId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cg_id']),
      inferredAmount: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}inferred_amount']),
      amount: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount'])!,
      amountBought: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount_bought'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      price: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}price'])!,
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      avgBuyPrice: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}avg_buy_price'])!,
      chart: $CryptosTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}chart']))!,
      isSupported: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_supported'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['contract_address'] = Variable<String>(contractAddress);
    if (!nullToAbsent || thumbnail != null) {
      map['thumbnail'] = Variable<String?>(thumbnail);
    }
    if (!nullToAbsent || cgId != null) {
      map['cg_id'] = Variable<String?>(cgId);
    }
    if (!nullToAbsent || inferredAmount != null) {
      map['inferred_amount'] = Variable<double?>(inferredAmount);
    }
    map['amount'] = Variable<double>(amount);
    map['amount_bought'] = Variable<double>(amountBought);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['id'] = Variable<String>(id);
    map['avg_buy_price'] = Variable<double>(avgBuyPrice);
    {
      final converter = $CryptosTable.$converter0;
      map['chart'] = Variable<String>(converter.mapToSql(chart)!);
    }
    map['is_supported'] = Variable<bool>(isSupported);
    return map;
  }

  CryptosCompanion toCompanion(bool nullToAbsent) {
    return CryptosCompanion(
      contractAddress: Value(contractAddress),
      thumbnail: thumbnail == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnail),
      cgId: cgId == null && nullToAbsent ? const Value.absent() : Value(cgId),
      inferredAmount: inferredAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(inferredAmount),
      amount: Value(amount),
      amountBought: Value(amountBought),
      name: Value(name),
      price: Value(price),
      id: Value(id),
      avgBuyPrice: Value(avgBuyPrice),
      chart: Value(chart),
      isSupported: Value(isSupported),
    );
  }

  factory dbCrypto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return dbCrypto(
      contractAddress: serializer.fromJson<String>(json['contractAddress']),
      thumbnail: serializer.fromJson<String?>(json['thumbnail']),
      cgId: serializer.fromJson<String?>(json['cgId']),
      inferredAmount: serializer.fromJson<double?>(json['inferredAmount']),
      amount: serializer.fromJson<double>(json['amount']),
      amountBought: serializer.fromJson<double>(json['amountBought']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      id: serializer.fromJson<String>(json['id']),
      avgBuyPrice: serializer.fromJson<double>(json['avgBuyPrice']),
      chart: serializer.fromJson<List<PricePoint>?>(json['chart']),
      isSupported: serializer.fromJson<bool>(json['isSupported']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contractAddress': serializer.toJson<String>(contractAddress),
      'thumbnail': serializer.toJson<String?>(thumbnail),
      'cgId': serializer.toJson<String?>(cgId),
      'inferredAmount': serializer.toJson<double?>(inferredAmount),
      'amount': serializer.toJson<double>(amount),
      'amountBought': serializer.toJson<double>(amountBought),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'id': serializer.toJson<String>(id),
      'avgBuyPrice': serializer.toJson<double>(avgBuyPrice),
      'chart': serializer.toJson<List<PricePoint>?>(chart),
      'isSupported': serializer.toJson<bool>(isSupported),
    };
  }

  dbCrypto copyWith(
          {String? contractAddress,
          String? thumbnail,
          String? cgId,
          double? inferredAmount,
          double? amount,
          double? amountBought,
          String? name,
          double? price,
          String? id,
          double? avgBuyPrice,
          List<PricePoint>? chart,
          bool? isSupported}) =>
      dbCrypto(
        contractAddress: contractAddress ?? this.contractAddress,
        thumbnail: thumbnail ?? this.thumbnail,
        cgId: cgId ?? this.cgId,
        inferredAmount: inferredAmount ?? this.inferredAmount,
        amount: amount ?? this.amount,
        amountBought: amountBought ?? this.amountBought,
        name: name ?? this.name,
        price: price ?? this.price,
        id: id ?? this.id,
        avgBuyPrice: avgBuyPrice ?? this.avgBuyPrice,
        chart: chart ?? this.chart,
        isSupported: isSupported ?? this.isSupported,
      );
  @override
  String toString() {
    return (StringBuffer('dbCrypto(')
          ..write('contractAddress: $contractAddress, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('cgId: $cgId, ')
          ..write('inferredAmount: $inferredAmount, ')
          ..write('amount: $amount, ')
          ..write('amountBought: $amountBought, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('id: $id, ')
          ..write('avgBuyPrice: $avgBuyPrice, ')
          ..write('chart: $chart, ')
          ..write('isSupported: $isSupported')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      contractAddress,
      thumbnail,
      cgId,
      inferredAmount,
      amount,
      amountBought,
      name,
      price,
      id,
      avgBuyPrice,
      chart,
      isSupported);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is dbCrypto &&
          other.contractAddress == this.contractAddress &&
          other.thumbnail == this.thumbnail &&
          other.cgId == this.cgId &&
          other.inferredAmount == this.inferredAmount &&
          other.amount == this.amount &&
          other.amountBought == this.amountBought &&
          other.name == this.name &&
          other.price == this.price &&
          other.id == this.id &&
          other.avgBuyPrice == this.avgBuyPrice &&
          other.chart == this.chart &&
          other.isSupported == this.isSupported);
}

class CryptosCompanion extends UpdateCompanion<dbCrypto> {
  final Value<String> contractAddress;
  final Value<String?> thumbnail;
  final Value<String?> cgId;
  final Value<double?> inferredAmount;
  final Value<double> amount;
  final Value<double> amountBought;
  final Value<String> name;
  final Value<double> price;
  final Value<String> id;
  final Value<double> avgBuyPrice;
  final Value<List<PricePoint>?> chart;
  final Value<bool> isSupported;
  const CryptosCompanion({
    this.contractAddress = const Value.absent(),
    this.thumbnail = const Value.absent(),
    this.cgId = const Value.absent(),
    this.inferredAmount = const Value.absent(),
    this.amount = const Value.absent(),
    this.amountBought = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.id = const Value.absent(),
    this.avgBuyPrice = const Value.absent(),
    this.chart = const Value.absent(),
    this.isSupported = const Value.absent(),
  });
  CryptosCompanion.insert({
    required String contractAddress,
    this.thumbnail = const Value.absent(),
    this.cgId = const Value.absent(),
    this.inferredAmount = const Value.absent(),
    required double amount,
    required double amountBought,
    required String name,
    required double price,
    required String id,
    required double avgBuyPrice,
    required List<PricePoint>? chart,
    required bool isSupported,
  })  : contractAddress = Value(contractAddress),
        amount = Value(amount),
        amountBought = Value(amountBought),
        name = Value(name),
        price = Value(price),
        id = Value(id),
        avgBuyPrice = Value(avgBuyPrice),
        chart = Value(chart),
        isSupported = Value(isSupported);
  static Insertable<dbCrypto> custom({
    Expression<String>? contractAddress,
    Expression<String?>? thumbnail,
    Expression<String?>? cgId,
    Expression<double?>? inferredAmount,
    Expression<double>? amount,
    Expression<double>? amountBought,
    Expression<String>? name,
    Expression<double>? price,
    Expression<String>? id,
    Expression<double>? avgBuyPrice,
    Expression<List<PricePoint>?>? chart,
    Expression<bool>? isSupported,
  }) {
    return RawValuesInsertable({
      if (contractAddress != null) 'contract_address': contractAddress,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (cgId != null) 'cg_id': cgId,
      if (inferredAmount != null) 'inferred_amount': inferredAmount,
      if (amount != null) 'amount': amount,
      if (amountBought != null) 'amount_bought': amountBought,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (id != null) 'id': id,
      if (avgBuyPrice != null) 'avg_buy_price': avgBuyPrice,
      if (chart != null) 'chart': chart,
      if (isSupported != null) 'is_supported': isSupported,
    });
  }

  CryptosCompanion copyWith(
      {Value<String>? contractAddress,
      Value<String?>? thumbnail,
      Value<String?>? cgId,
      Value<double?>? inferredAmount,
      Value<double>? amount,
      Value<double>? amountBought,
      Value<String>? name,
      Value<double>? price,
      Value<String>? id,
      Value<double>? avgBuyPrice,
      Value<List<PricePoint>?>? chart,
      Value<bool>? isSupported}) {
    return CryptosCompanion(
      contractAddress: contractAddress ?? this.contractAddress,
      thumbnail: thumbnail ?? this.thumbnail,
      cgId: cgId ?? this.cgId,
      inferredAmount: inferredAmount ?? this.inferredAmount,
      amount: amount ?? this.amount,
      amountBought: amountBought ?? this.amountBought,
      name: name ?? this.name,
      price: price ?? this.price,
      id: id ?? this.id,
      avgBuyPrice: avgBuyPrice ?? this.avgBuyPrice,
      chart: chart ?? this.chart,
      isSupported: isSupported ?? this.isSupported,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contractAddress.present) {
      map['contract_address'] = Variable<String>(contractAddress.value);
    }
    if (thumbnail.present) {
      map['thumbnail'] = Variable<String?>(thumbnail.value);
    }
    if (cgId.present) {
      map['cg_id'] = Variable<String?>(cgId.value);
    }
    if (inferredAmount.present) {
      map['inferred_amount'] = Variable<double?>(inferredAmount.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (amountBought.present) {
      map['amount_bought'] = Variable<double>(amountBought.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (avgBuyPrice.present) {
      map['avg_buy_price'] = Variable<double>(avgBuyPrice.value);
    }
    if (chart.present) {
      final converter = $CryptosTable.$converter0;
      map['chart'] = Variable<String>(converter.mapToSql(chart.value)!);
    }
    if (isSupported.present) {
      map['is_supported'] = Variable<bool>(isSupported.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CryptosCompanion(')
          ..write('contractAddress: $contractAddress, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('cgId: $cgId, ')
          ..write('inferredAmount: $inferredAmount, ')
          ..write('amount: $amount, ')
          ..write('amountBought: $amountBought, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('id: $id, ')
          ..write('avgBuyPrice: $avgBuyPrice, ')
          ..write('chart: $chart, ')
          ..write('isSupported: $isSupported')
          ..write(')'))
        .toString();
  }
}

class $CryptosTable extends Cryptos with TableInfo<$CryptosTable, dbCrypto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CryptosTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _contractAddressMeta =
      const VerificationMeta('contractAddress');
  @override
  late final GeneratedColumn<String?> contractAddress =
      GeneratedColumn<String?>('contract_address', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _thumbnailMeta = const VerificationMeta('thumbnail');
  @override
  late final GeneratedColumn<String?> thumbnail = GeneratedColumn<String?>(
      'thumbnail', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _cgIdMeta = const VerificationMeta('cgId');
  @override
  late final GeneratedColumn<String?> cgId = GeneratedColumn<String?>(
      'cg_id', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _inferredAmountMeta =
      const VerificationMeta('inferredAmount');
  @override
  late final GeneratedColumn<double?> inferredAmount = GeneratedColumn<double?>(
      'inferred_amount', aliasedName, true,
      type: const RealType(), requiredDuringInsert: false);
  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double?> amount = GeneratedColumn<double?>(
      'amount', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _amountBoughtMeta =
      const VerificationMeta('amountBought');
  @override
  late final GeneratedColumn<double?> amountBought = GeneratedColumn<double?>(
      'amount_bought', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double?> price = GeneratedColumn<double?>(
      'price', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _avgBuyPriceMeta =
      const VerificationMeta('avgBuyPrice');
  @override
  late final GeneratedColumn<double?> avgBuyPrice = GeneratedColumn<double?>(
      'avg_buy_price', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _chartMeta = const VerificationMeta('chart');
  @override
  late final GeneratedColumnWithTypeConverter<List<PricePoint>?, String?>
      chart = GeneratedColumn<String?>('chart', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<List<PricePoint>?>($CryptosTable.$converter0);
  final VerificationMeta _isSupportedMeta =
      const VerificationMeta('isSupported');
  @override
  late final GeneratedColumn<bool?> isSupported = GeneratedColumn<bool?>(
      'is_supported', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_supported IN (0, 1))');
  @override
  List<GeneratedColumn> get $columns => [
        contractAddress,
        thumbnail,
        cgId,
        inferredAmount,
        amount,
        amountBought,
        name,
        price,
        id,
        avgBuyPrice,
        chart,
        isSupported
      ];
  @override
  String get aliasedName => _alias ?? 'cryptos';
  @override
  String get actualTableName => 'cryptos';
  @override
  VerificationContext validateIntegrity(Insertable<dbCrypto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('contract_address')) {
      context.handle(
          _contractAddressMeta,
          contractAddress.isAcceptableOrUnknown(
              data['contract_address']!, _contractAddressMeta));
    } else if (isInserting) {
      context.missing(_contractAddressMeta);
    }
    if (data.containsKey('thumbnail')) {
      context.handle(_thumbnailMeta,
          thumbnail.isAcceptableOrUnknown(data['thumbnail']!, _thumbnailMeta));
    }
    if (data.containsKey('cg_id')) {
      context.handle(
          _cgIdMeta, cgId.isAcceptableOrUnknown(data['cg_id']!, _cgIdMeta));
    }
    if (data.containsKey('inferred_amount')) {
      context.handle(
          _inferredAmountMeta,
          inferredAmount.isAcceptableOrUnknown(
              data['inferred_amount']!, _inferredAmountMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('amount_bought')) {
      context.handle(
          _amountBoughtMeta,
          amountBought.isAcceptableOrUnknown(
              data['amount_bought']!, _amountBoughtMeta));
    } else if (isInserting) {
      context.missing(_amountBoughtMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('avg_buy_price')) {
      context.handle(
          _avgBuyPriceMeta,
          avgBuyPrice.isAcceptableOrUnknown(
              data['avg_buy_price']!, _avgBuyPriceMeta));
    } else if (isInserting) {
      context.missing(_avgBuyPriceMeta);
    }
    context.handle(_chartMeta, const VerificationResult.success());
    if (data.containsKey('is_supported')) {
      context.handle(
          _isSupportedMeta,
          isSupported.isAcceptableOrUnknown(
              data['is_supported']!, _isSupportedMeta));
    } else if (isInserting) {
      context.missing(_isSupportedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contractAddress};
  @override
  dbCrypto map(Map<String, dynamic> data, {String? tablePrefix}) {
    return dbCrypto.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CryptosTable createAlias(String alias) {
    return $CryptosTable(attachedDatabase, alias);
  }

  static TypeConverter<List<PricePoint>?, String> $converter0 =
      const ChartConverter();
}

class dbCryptoTX extends DataClass implements Insertable<dbCryptoTX> {
  final DateTime time;
  final double amount;
  final String name;
  final String id;
  final String action;
  final String contractAddress;
  final int decimals;
  final String clientAddress;
  final String platform;
  dbCryptoTX(
      {required this.time,
      required this.amount,
      required this.name,
      required this.id,
      required this.action,
      required this.contractAddress,
      required this.decimals,
      required this.clientAddress,
      required this.platform});
  factory dbCryptoTX.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return dbCryptoTX(
      time: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time'])!,
      amount: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      action: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}action'])!,
      contractAddress: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}contract_address'])!,
      decimals: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}decimals'])!,
      clientAddress: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}client_address'])!,
      platform: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}platform'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['time'] = Variable<DateTime>(time);
    map['amount'] = Variable<double>(amount);
    map['name'] = Variable<String>(name);
    map['id'] = Variable<String>(id);
    map['action'] = Variable<String>(action);
    map['contract_address'] = Variable<String>(contractAddress);
    map['decimals'] = Variable<int>(decimals);
    map['client_address'] = Variable<String>(clientAddress);
    map['platform'] = Variable<String>(platform);
    return map;
  }

  CryptoTXsCompanion toCompanion(bool nullToAbsent) {
    return CryptoTXsCompanion(
      time: Value(time),
      amount: Value(amount),
      name: Value(name),
      id: Value(id),
      action: Value(action),
      contractAddress: Value(contractAddress),
      decimals: Value(decimals),
      clientAddress: Value(clientAddress),
      platform: Value(platform),
    );
  }

  factory dbCryptoTX.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return dbCryptoTX(
      time: serializer.fromJson<DateTime>(json['time']),
      amount: serializer.fromJson<double>(json['amount']),
      name: serializer.fromJson<String>(json['name']),
      id: serializer.fromJson<String>(json['id']),
      action: serializer.fromJson<String>(json['action']),
      contractAddress: serializer.fromJson<String>(json['contractAddress']),
      decimals: serializer.fromJson<int>(json['decimals']),
      clientAddress: serializer.fromJson<String>(json['clientAddress']),
      platform: serializer.fromJson<String>(json['platform']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'time': serializer.toJson<DateTime>(time),
      'amount': serializer.toJson<double>(amount),
      'name': serializer.toJson<String>(name),
      'id': serializer.toJson<String>(id),
      'action': serializer.toJson<String>(action),
      'contractAddress': serializer.toJson<String>(contractAddress),
      'decimals': serializer.toJson<int>(decimals),
      'clientAddress': serializer.toJson<String>(clientAddress),
      'platform': serializer.toJson<String>(platform),
    };
  }

  dbCryptoTX copyWith(
          {DateTime? time,
          double? amount,
          String? name,
          String? id,
          String? action,
          String? contractAddress,
          int? decimals,
          String? clientAddress,
          String? platform}) =>
      dbCryptoTX(
        time: time ?? this.time,
        amount: amount ?? this.amount,
        name: name ?? this.name,
        id: id ?? this.id,
        action: action ?? this.action,
        contractAddress: contractAddress ?? this.contractAddress,
        decimals: decimals ?? this.decimals,
        clientAddress: clientAddress ?? this.clientAddress,
        platform: platform ?? this.platform,
      );
  @override
  String toString() {
    return (StringBuffer('dbCryptoTX(')
          ..write('time: $time, ')
          ..write('amount: $amount, ')
          ..write('name: $name, ')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('contractAddress: $contractAddress, ')
          ..write('decimals: $decimals, ')
          ..write('clientAddress: $clientAddress, ')
          ..write('platform: $platform')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(time, amount, name, id, action,
      contractAddress, decimals, clientAddress, platform);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is dbCryptoTX &&
          other.time == this.time &&
          other.amount == this.amount &&
          other.name == this.name &&
          other.id == this.id &&
          other.action == this.action &&
          other.contractAddress == this.contractAddress &&
          other.decimals == this.decimals &&
          other.clientAddress == this.clientAddress &&
          other.platform == this.platform);
}

class CryptoTXsCompanion extends UpdateCompanion<dbCryptoTX> {
  final Value<DateTime> time;
  final Value<double> amount;
  final Value<String> name;
  final Value<String> id;
  final Value<String> action;
  final Value<String> contractAddress;
  final Value<int> decimals;
  final Value<String> clientAddress;
  final Value<String> platform;
  const CryptoTXsCompanion({
    this.time = const Value.absent(),
    this.amount = const Value.absent(),
    this.name = const Value.absent(),
    this.id = const Value.absent(),
    this.action = const Value.absent(),
    this.contractAddress = const Value.absent(),
    this.decimals = const Value.absent(),
    this.clientAddress = const Value.absent(),
    this.platform = const Value.absent(),
  });
  CryptoTXsCompanion.insert({
    required DateTime time,
    required double amount,
    required String name,
    required String id,
    required String action,
    required String contractAddress,
    required int decimals,
    required String clientAddress,
    required String platform,
  })  : time = Value(time),
        amount = Value(amount),
        name = Value(name),
        id = Value(id),
        action = Value(action),
        contractAddress = Value(contractAddress),
        decimals = Value(decimals),
        clientAddress = Value(clientAddress),
        platform = Value(platform);
  static Insertable<dbCryptoTX> custom({
    Expression<DateTime>? time,
    Expression<double>? amount,
    Expression<String>? name,
    Expression<String>? id,
    Expression<String>? action,
    Expression<String>? contractAddress,
    Expression<int>? decimals,
    Expression<String>? clientAddress,
    Expression<String>? platform,
  }) {
    return RawValuesInsertable({
      if (time != null) 'time': time,
      if (amount != null) 'amount': amount,
      if (name != null) 'name': name,
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (contractAddress != null) 'contract_address': contractAddress,
      if (decimals != null) 'decimals': decimals,
      if (clientAddress != null) 'client_address': clientAddress,
      if (platform != null) 'platform': platform,
    });
  }

  CryptoTXsCompanion copyWith(
      {Value<DateTime>? time,
      Value<double>? amount,
      Value<String>? name,
      Value<String>? id,
      Value<String>? action,
      Value<String>? contractAddress,
      Value<int>? decimals,
      Value<String>? clientAddress,
      Value<String>? platform}) {
    return CryptoTXsCompanion(
      time: time ?? this.time,
      amount: amount ?? this.amount,
      name: name ?? this.name,
      id: id ?? this.id,
      action: action ?? this.action,
      contractAddress: contractAddress ?? this.contractAddress,
      decimals: decimals ?? this.decimals,
      clientAddress: clientAddress ?? this.clientAddress,
      platform: platform ?? this.platform,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (contractAddress.present) {
      map['contract_address'] = Variable<String>(contractAddress.value);
    }
    if (decimals.present) {
      map['decimals'] = Variable<int>(decimals.value);
    }
    if (clientAddress.present) {
      map['client_address'] = Variable<String>(clientAddress.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CryptoTXsCompanion(')
          ..write('time: $time, ')
          ..write('amount: $amount, ')
          ..write('name: $name, ')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('contractAddress: $contractAddress, ')
          ..write('decimals: $decimals, ')
          ..write('clientAddress: $clientAddress, ')
          ..write('platform: $platform')
          ..write(')'))
        .toString();
  }
}

class $CryptoTXsTable extends CryptoTXs
    with TableInfo<$CryptoTXsTable, dbCryptoTX> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CryptoTXsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime?> time = GeneratedColumn<DateTime?>(
      'time', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double?> amount = GeneratedColumn<double?>(
      'amount', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String?> action = GeneratedColumn<String?>(
      'action', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _contractAddressMeta =
      const VerificationMeta('contractAddress');
  @override
  late final GeneratedColumn<String?> contractAddress =
      GeneratedColumn<String?>('contract_address', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _decimalsMeta = const VerificationMeta('decimals');
  @override
  late final GeneratedColumn<int?> decimals = GeneratedColumn<int?>(
      'decimals', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _clientAddressMeta =
      const VerificationMeta('clientAddress');
  @override
  late final GeneratedColumn<String?> clientAddress = GeneratedColumn<String?>(
      'client_address', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _platformMeta = const VerificationMeta('platform');
  @override
  late final GeneratedColumn<String?> platform = GeneratedColumn<String?>(
      'platform', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        time,
        amount,
        name,
        id,
        action,
        contractAddress,
        decimals,
        clientAddress,
        platform
      ];
  @override
  String get aliasedName => _alias ?? 'crypto_t_xs';
  @override
  String get actualTableName => 'crypto_t_xs';
  @override
  VerificationContext validateIntegrity(Insertable<dbCryptoTX> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('contract_address')) {
      context.handle(
          _contractAddressMeta,
          contractAddress.isAcceptableOrUnknown(
              data['contract_address']!, _contractAddressMeta));
    } else if (isInserting) {
      context.missing(_contractAddressMeta);
    }
    if (data.containsKey('decimals')) {
      context.handle(_decimalsMeta,
          decimals.isAcceptableOrUnknown(data['decimals']!, _decimalsMeta));
    } else if (isInserting) {
      context.missing(_decimalsMeta);
    }
    if (data.containsKey('client_address')) {
      context.handle(
          _clientAddressMeta,
          clientAddress.isAcceptableOrUnknown(
              data['client_address']!, _clientAddressMeta));
    } else if (isInserting) {
      context.missing(_clientAddressMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(_platformMeta,
          platform.isAcceptableOrUnknown(data['platform']!, _platformMeta));
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  dbCryptoTX map(Map<String, dynamic> data, {String? tablePrefix}) {
    return dbCryptoTX.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CryptoTXsTable createAlias(String alias) {
    return $CryptoTXsTable(attachedDatabase, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $WalletsTable wallets = $WalletsTable(this);
  late final $CryptosTable cryptos = $CryptosTable(this);
  late final $CryptoTXsTable cryptoTXs = $CryptoTXsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [wallets, cryptos, cryptoTXs];
}
