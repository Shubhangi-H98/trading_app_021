import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/datasources/local_storage_service.dart';
import '../../../data/model/holding_model.dart';
import '../../../data/model/order_model.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final LocalStorageService _storageService;

  PortfolioBloc(this._storageService) : super(const PortfolioState()) {
    on<LoadPortfolioEvent>(_onLoadPortfolio);
    on<ExecuteOrderEvent>(_onExecuteOrder);
    on<SortHoldingsEvent>(_onSortHoldings);
    on<AddFundsEvent>(_onAddFunds);
  }

  void _onLoadPortfolio(LoadPortfolioEvent event, Emitter<PortfolioState> emit) {
    emit(state.copyWith(status: PortfolioStatus.loading));
    final balance = _storageService.getWalletBalance();
    final holdings = _storageService.getHoldings();
    final orders = _storageService.getOrders();

    emit(state.copyWith(
      status: PortfolioStatus.loaded,
      walletBalance: balance,
      holdings: holdings,
      orders: orders,
    ));
  }

  Future<void> _onAddFunds(AddFundsEvent event, Emitter<PortfolioState> emit) async {
    final updatedBalance = CurrencyFormatter.roundTo2Decimals(state.walletBalance + event.amount);
    await _storageService.saveWalletBalance(updatedBalance);
    emit(state.copyWith(
      walletBalance: updatedBalance,
      successMessage: '${CurrencyFormatter.format(event.amount)} added to wallet!',
    ));
  }

  Future<void> _onExecuteOrder(ExecuteOrderEvent event, Emitter<PortfolioState> emit) async {
    final orderValue = CurrencyFormatter.roundTo2Decimals(event.quantity * event.price);

    // 1. Validations
    if (event.quantity <= 0) {
      emit(state.copyWith(errorMessage: 'Quantity must be greater than zero'));
      return;
    }

    if (event.side == OrderType.buy) {
      if (orderValue > state.walletBalance) {
        emit(state.copyWith(errorMessage: 'Insufficient balance to place order'));
        return;
      }
    } else {
      // Sell validation
      final existingHolding = state.holdings.firstWhere(
            (h) => h.symbol == event.symbol,
        orElse: () => const HoldingModel(symbol: '', quantity: 0, averageBuyPrice: 0),
      );

      if (existingHolding.quantity < event.quantity) {
        emit(state.copyWith(
          errorMessage: 'Cannot sell more than held quantity (${existingHolding.quantity} available)',
        ));
        return;
      }
    }

    // 2. Update Balance
    final double updatedBalance = event.side == OrderType.buy
        ? CurrencyFormatter.roundTo2Decimals(state.walletBalance - orderValue)
        : CurrencyFormatter.roundTo2Decimals(state.walletBalance + orderValue);

    // 3. Update Holdings
    final updatedHoldings = List<HoldingModel>.from(state.holdings);
    final holdingIndex = updatedHoldings.indexWhere((h) => h.symbol == event.symbol);

    if (event.side == OrderType.buy) {
      if (holdingIndex >= 0) {
        final current = updatedHoldings[holdingIndex];
        final totalOldCost = current.quantity * current.averageBuyPrice;
        final totalNewCost = totalOldCost + orderValue;
        final totalQty = current.quantity + event.quantity;
        final newAvg = CurrencyFormatter.roundTo2Decimals(totalNewCost / totalQty);

        updatedHoldings[holdingIndex] = current.copyWith(
          quantity: totalQty,
          averageBuyPrice: newAvg,
        );
      } else {
        updatedHoldings.add(
          HoldingModel(
            symbol: event.symbol,
            quantity: event.quantity,
            averageBuyPrice: event.price,
          ),
        );
      }
    } else {
      // Sell execution
      final current = updatedHoldings[holdingIndex];
      final remainingQty = current.quantity - event.quantity;
      if (remainingQty == 0) {
        updatedHoldings.removeAt(holdingIndex);
      } else {
        updatedHoldings[holdingIndex] = current.copyWith(quantity: remainingQty);
      }
    }

    // 4. Record Order History
    final newOrder = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symbol: event.symbol,
      type: event.side,
      quantity: event.quantity,
      executionPrice: event.price,
      totalValue: orderValue,
      executedAt: DateTime.now(),
    );

    // 5. Persist Everything to Local Storage
    await _storageService.saveWalletBalance(updatedBalance);
    await _storageService.saveHoldings(updatedHoldings);
    await _storageService.saveOrder(newOrder);

    emit(state.copyWith(
      walletBalance: updatedBalance,
      holdings: updatedHoldings,
      orders: [newOrder, ...state.orders],
      successMessage: '${event.side.name.toUpperCase()} order executed for ${event.symbol}!',
    ));
  }

  void _onSortHoldings(SortHoldingsEvent event, Emitter<PortfolioState> emit) {
    emit(state.copyWith(sortCriteria: event.criteria));
  }
}