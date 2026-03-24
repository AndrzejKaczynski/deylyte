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

abstract class DailyAvgPrice implements _i1.SerializableModel {
  DailyAvgPrice._({
    required this.date,
    required this.avgBuyPrice,
    required this.avgSellPrice,
  });

  factory DailyAvgPrice({
    required DateTime date,
    required double avgBuyPrice,
    required double avgSellPrice,
  }) = _DailyAvgPriceImpl;

  factory DailyAvgPrice.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyAvgPrice(
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      avgBuyPrice: (jsonSerialization['avgBuyPrice'] as num).toDouble(),
      avgSellPrice: (jsonSerialization['avgSellPrice'] as num).toDouble(),
    );
  }

  DateTime date;

  double avgBuyPrice;

  double avgSellPrice;

  /// Returns a shallow copy of this [DailyAvgPrice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DailyAvgPrice copyWith({
    DateTime? date,
    double? avgBuyPrice,
    double? avgSellPrice,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyAvgPrice',
      'date': date.toJson(),
      'avgBuyPrice': avgBuyPrice,
      'avgSellPrice': avgSellPrice,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DailyAvgPriceImpl extends DailyAvgPrice {
  _DailyAvgPriceImpl({
    required DateTime date,
    required double avgBuyPrice,
    required double avgSellPrice,
  }) : super._(
         date: date,
         avgBuyPrice: avgBuyPrice,
         avgSellPrice: avgSellPrice,
       );

  /// Returns a shallow copy of this [DailyAvgPrice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DailyAvgPrice copyWith({
    DateTime? date,
    double? avgBuyPrice,
    double? avgSellPrice,
  }) {
    return DailyAvgPrice(
      date: date ?? this.date,
      avgBuyPrice: avgBuyPrice ?? this.avgBuyPrice,
      avgSellPrice: avgSellPrice ?? this.avgSellPrice,
    );
  }
}
