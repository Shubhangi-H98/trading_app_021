import 'package:equatable/equatable.dart';
import '../../../data/model/stock_model.dart';

enum MarketStatus { initial, loading, live }

class MarketState extends Equatable {
  final MarketStatus status;
  final Map<String, StockModel> stocks;
  final int tickRate;

  const MarketState({
    this.status = MarketStatus.initial,
    this.stocks = const {},
    this.tickRate = 2,
  });

  MarketState copyWith({
    MarketStatus? status,
    Map<String, StockModel>? stocks,
    int? tickRate,
  }) {
    return MarketState(
      status: status ?? this.status,
      stocks: stocks ?? this.stocks,
      tickRate: tickRate ?? this.tickRate,
    );
  }

  @override
  List<Object?> get props => [status, stocks, tickRate];
}