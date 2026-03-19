/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class EnergyPrice implements _i1.SerializableModel {
  EnergyPrice._({
    this.id,
    required this.userInfoId,
    required this.timestamp,
    required this.buyPrice,
    required this.sellPrice,
    required this.currency,
  });

  factory EnergyPrice({
    int? id,
    required int userInfoId,
    required DateTime timestamp,
    required double buyPrice,
    required double sellPrice,
    required String currency,
  }) = _EnergyPriceImpl;

  factory EnergyPrice.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnergyPrice(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      buyPrice: (jsonSerialization['buyPrice'] as num).toDouble(),
      sellPrice: (jsonSerialization['sellPrice'] as num).toDouble(),
      currency: jsonSerialization['currency'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  DateTime timestamp;

  double buyPrice;

  double sellPrice;

  String currency;

  /// Returns a shallow copy of this [EnergyPrice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EnergyPrice copyWith({
    int? id,
    int? userInfoId,
    DateTime? timestamp,
    double? buyPrice,
    double? sellPrice,
    String? currency,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EnergyPrice',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'timestamp': timestamp.toJson(),
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'currency': currency,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnergyPriceImpl extends EnergyPrice {
  _EnergyPriceImpl({
    int? id,
    required int userInfoId,
    required DateTime timestamp,
    required double buyPrice,
    required double sellPrice,
    required String currency,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         timestamp: timestamp,
         buyPrice: buyPrice,
         sellPrice: sellPrice,
         currency: currency,
       );

  /// Returns a shallow copy of this [EnergyPrice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EnergyPrice copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    DateTime? timestamp,
    double? buyPrice,
    double? sellPrice,
    String? currency,
  }) {
    return EnergyPrice(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      timestamp: timestamp ?? this.timestamp,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      currency: currency ?? this.currency,
    );
  }
}
