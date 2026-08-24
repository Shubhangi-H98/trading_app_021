import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/feedback_helper.dart';
import '../../../data/model/holding_model.dart';
import '../../../data/model/order_model.dart';
import '../../holdings/bloc/portfolio_bloc.dart';
import '../../holdings/bloc/portfolio_event.dart  Dart.dart';
import '../../holdings/bloc/portfolio_state.dart';
import '../../market/bloc/market_bloc.dart';
import '../../market/bloc/market_state.dart';

class OrderTicketBottomSheet extends StatefulWidget {
  final String symbol;

  const OrderTicketBottomSheet({super.key, required this.symbol});

  static void show(BuildContext context, String symbol) {
    FeedbackHelper.lightClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrderTicketBottomSheet(symbol: symbol),
    );
  }

  @override
  State<OrderTicketBottomSheet> createState() => _OrderTicketBottomSheetState();
}

class _OrderTicketBottomSheetState extends State<OrderTicketBottomSheet> {
  OrderType _side = OrderType.buy;
  final TextEditingController _qtyController = TextEditingController(text: '1');
  int _quantity = 1;
  String? _inlineError;

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  void _onQtyChanged(String val) {
    final parsed = int.tryParse(val);
    setState(() {
      if (parsed == null || parsed <= 0) {
        _quantity = 0;
        _inlineError = 'Enter valid quantity (> 0)';
      } else {
        _quantity = parsed;
        _inlineError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<MarketBloc, MarketState>(
      builder: (context, marketState) {
        final stock = marketState.stocks[widget.symbol];
        final currentLtp = stock?.ltp ?? 0.0;

        return BlocBuilder<PortfolioBloc, PortfolioState>(
          builder: (context, portfolioState) {
            final orderTotal = CurrencyFormatter.roundTo2Decimals(_quantity * currentLtp);
            final walletBalance = portfolioState.walletBalance;

            final existingHolding = portfolioState.holdings.firstWhere(
                  (h) => h.symbol == widget.symbol,
              orElse: () => const HoldingModel(symbol: '', quantity: 0, averageBuyPrice: 0),
            );
            final availableQty = existingHolding.quantity;

            // Live Inline Validation
            String? error = _inlineError;
            if (_quantity > 0) {
              if (_side == OrderType.buy && orderTotal > walletBalance) {
                error = 'Insufficient funds (Needed: ${CurrencyFormatter.format(orderTotal)})';
              } else if (_side == OrderType.sell && _quantity > availableQty) {
                error = 'Only $availableQty shares available to sell';
              }
            }

            final isBuy = _side == OrderType.buy;
            final themeColor = isBuy ? AppColors.greenUp : AppColors.redDown;
            final inactiveBtnBg = isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200;
            final inactiveBtnFg = isDark ? Colors.white70 : Colors.black87;

            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Header with Symbol & Live LTP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.symbol,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'NSE Regular Market Order',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyFormatter.format(currentLtp),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: stock?.change != null && stock!.change >= 0
                                  ? AppColors.greenUp
                                  : AppColors.redDown,
                            ),
                          ),
                          if (stock != null)
                            Text(
                              CurrencyFormatter.formatChange(stock.change, stock.changePercent),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // BUY / SELL Toggle Selector
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            FeedbackHelper.lightClick();
                            setState(() => _side = OrderType.buy);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isBuy ? AppColors.greenUp : inactiveBtnBg,
                            foregroundColor: isBuy ? Colors.white : inactiveBtnFg,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('BUY', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            FeedbackHelper.lightClick();
                            setState(() => _side = OrderType.sell);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isBuy ? AppColors.redDown : inactiveBtnBg,
                            foregroundColor: !isBuy ? Colors.white : inactiveBtnFg,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('SELL', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Quantity Input Field
                  TextField(
                    controller: _qtyController,
                    keyboardType: TextInputType.number,
                    onChanged: _onQtyChanged,
                    decoration: InputDecoration(
                      labelText: 'Quantity (Shares)',
                      prefixIcon: const Icon(Icons.pin),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Info bar: Available Balance / Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBuy
                            ? 'Available Balance: ${CurrencyFormatter.format(walletBalance)}'
                            : 'Held Quantity: $availableQty Shares',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      Text(
                        'Total: ${CurrencyFormatter.format(orderTotal)}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  // Inline Validation Error message
                  if (error != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.red.shade900.withOpacity(0.4) : AppColors.redFlash,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        error,
                        style: const TextStyle(
                          color: AppColors.redDown,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Execute Order Button with Haptic & Sound Confirmation
                  ElevatedButton(
                    onPressed: error == null && _quantity > 0 && currentLtp > 0
                        ? () {
                      FeedbackHelper.orderSuccess();
                      context.read<PortfolioBloc>().add(
                        ExecuteOrderEvent(
                          symbol: widget.symbol,
                          side: _side,
                          quantity: _quantity,
                          price: currentLtp,
                        ),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${_side.name.toUpperCase()} $_quantity ${widget.symbol} @ ${CurrencyFormatter.format(currentLtp)} successful!',
                          ),
                          backgroundColor: isBuy ? AppColors.greenUp : AppColors.primary,
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'SUBMIT ${_side.name.toUpperCase()} ORDER',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}