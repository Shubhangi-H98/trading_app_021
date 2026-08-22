import 'package:equatable/equatable.dart';

enum PriceDirection { up, down, unchanged }

class StockModel extends Equatable {
  final String symbol;
  final double ltp;
  final double previousClose;
  final double change;
  final double changePercent;
  final PriceDirection direction;
  final DateTime lastUpdated;

  const StockModel({
    required this.symbol,
    required this.ltp,
    required this.previousClose,
    required this.change,
    required this.changePercent,
    this.direction = PriceDirection.unchanged,
    required this.lastUpdated,
  });

  StockModel copyWith({
    double? ltp,
    double? previousClose,
    double? change,
    double? changePercent,
    PriceDirection? direction,
    DateTime? lastUpdated,
  }) {
    return StockModel(
      symbol: symbol,
      ltp: ltp ?? this.ltp,
      previousClose: previousClose ?? this.previousClose,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
      direction: direction ?? this.direction,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'ltp': ltp,
    'previousClose': previousClose,
    'change': change,
    'changePercent': changePercent,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
    symbol: json['symbol'] as String,
    ltp: (json['ltp'] as num).toDouble(),
    previousClose: (json['previousClose'] as num).toDouble(),
    change: (json['change'] as num).toDouble(),
    changePercent: (json['changePercent'] as num).toDouble(),
    lastUpdated: DateTime.parse(json['lastUpdated'] as String),
  );

  @override
  List<Object?> get props => [symbol, ltp, change, changePercent, direction];
}