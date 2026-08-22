import 'package:equatable/equatable.dart';

enum OrderType { buy, sell }

class OrderModel extends Equatable {
  final String id;
  final String symbol;
  final OrderType type;
  final int quantity;
  final double executionPrice;
  final double totalValue;
  final DateTime executedAt;

  const OrderModel({
    required this.id,
    required this.symbol,
    required this.type,
    required this.quantity,
    required this.executionPrice,
    required this.totalValue,
    required this.executedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'symbol': symbol,
    'type': type.name,
    'quantity': quantity,
    'executionPrice': executionPrice,
    'totalValue': totalValue,
    'executedAt': executedAt.toIso8601String(),
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'] as String,
    symbol: json['symbol'] as String,
    type: OrderType.values.byName(json['type'] as String),
    quantity: json['quantity'] as int,
    executionPrice: (json['executionPrice'] as num).toDouble(),
    totalValue: (json['totalValue'] as num).toDouble(),
    executedAt: DateTime.parse(json['executedAt'] as String),
  );

  @override
  List<Object?> get props => [id, symbol, type, quantity, executionPrice, totalValue, executedAt];
}