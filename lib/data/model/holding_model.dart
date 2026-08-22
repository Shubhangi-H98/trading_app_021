import 'package:equatable/equatable.dart';

class HoldingModel extends Equatable {
  final String symbol;
  final int quantity;
  final double averageBuyPrice;

  const HoldingModel({
    required this.symbol,
    required this.quantity,
    required this.averageBuyPrice,
  });

  double get investedValue => quantity * averageBuyPrice;

  HoldingModel copyWith({
    int? quantity,
    double? averageBuyPrice,
  }) {
    return HoldingModel(
      symbol: symbol,
      quantity: quantity ?? this.quantity,
      averageBuyPrice: averageBuyPrice ?? this.averageBuyPrice,
    );
  }

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'quantity': quantity,
    'averageBuyPrice': averageBuyPrice,
  };

  factory HoldingModel.fromJson(Map<String, dynamic> json) => HoldingModel(
    symbol: json['symbol'] as String,
    quantity: json['quantity'] as int,
    averageBuyPrice: (json['averageBuyPrice'] as num).toDouble(),
  );

  @override
  List<Object?> get props => [symbol, quantity, averageBuyPrice];
}