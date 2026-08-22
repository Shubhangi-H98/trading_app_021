import 'package:equatable/equatable.dart';

import '../../../data/model/order_model.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();
  @override
  List<Object?> get props => [];
}

class LoadPortfolioEvent extends PortfolioEvent {}

class ExecuteOrderEvent extends PortfolioEvent {
  final String symbol;
  final OrderType side;
  final int quantity;
  final double price;

  const ExecuteOrderEvent({
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [symbol, side, quantity, price];
}

enum HoldingSortCriteria { pl, symbol, currentValue }

class SortHoldingsEvent extends PortfolioEvent {
  final HoldingSortCriteria criteria;
  const SortHoldingsEvent(this.criteria);

  @override
  List<Object?> get props => [criteria];
}