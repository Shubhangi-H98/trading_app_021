import 'package:equatable/equatable.dart';
import '../../../data/model/stock_model.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();
  @override
  List<Object?> get props => [];
}

class StartMarketFeedEvent extends MarketEvent {}

class MarketPricesUpdatedEvent extends MarketEvent {
  final Map<String, StockModel> stocks;
  const MarketPricesUpdatedEvent(this.stocks);
  @override
  List<Object?> get props => [stocks];
}

class ChangeTickRateEvent extends MarketEvent {
  final int tickRate;
  const ChangeTickRateEvent(this.tickRate);
  @override
  List<Object?> get props => [tickRate];
}