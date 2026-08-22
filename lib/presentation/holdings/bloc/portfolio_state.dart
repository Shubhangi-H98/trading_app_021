import 'package:equatable/equatable.dart';
import 'package:trading_app_021/presentation/holdings/bloc/portfolio_event.dart%20%20Dart.dart';

import '../../../data/model/holding_model.dart';
import '../../../data/model/order_model.dart';

enum PortfolioStatus { initial, loading, loaded, error }

class PortfolioState extends Equatable {
  final PortfolioStatus status;
  final double walletBalance;
  final List<HoldingModel> holdings;
  final List<OrderModel> orders;
  final HoldingSortCriteria sortCriteria;
  final String? errorMessage;
  final String? successMessage;

  const PortfolioState({
    this.status = PortfolioStatus.initial,
    this.walletBalance = 500000.0,
    this.holdings = const [],
    this.orders = const [],
    this.sortCriteria = HoldingSortCriteria.pl,
    this.errorMessage,
    this.successMessage,
  });

  PortfolioState copyWith({
    PortfolioStatus? status,
    double? walletBalance,
    List<HoldingModel>? holdings,
    List<OrderModel>? orders,
    HoldingSortCriteria? sortCriteria,
    String? errorMessage,
    String? successMessage,
  }) {
    return PortfolioState(
      status: status ?? this.status,
      walletBalance: walletBalance ?? this.walletBalance,
      holdings: holdings ?? this.holdings,
      orders: orders ?? this.orders,
      sortCriteria: sortCriteria ?? this.sortCriteria,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    walletBalance,
    holdings,
    orders,
    sortCriteria,
    errorMessage,
    successMessage,
  ];
}