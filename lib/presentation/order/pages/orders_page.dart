import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/model/order_model.dart';
import '../../dashboard/widgets/app_side_drawer.dart';
import '../../holdings/bloc/portfolio_bloc.dart';
import '../../holdings/bloc/portfolio_state.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: const AppSideDrawer(),
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: Builder(
          builder: (innerCtx) => IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Open Menu',
            onPressed: () => Scaffold.of(innerCtx).openDrawer(),
          ),
        ),
        title: const Text('Tradebook & Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0.5,
      ),
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) {
          final orders = state.orders.reversed.toList(); // Latest orders first

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                  ),
                  const SizedBox(height: 12),
                  const Text('No executed trades yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'Execute Buy/Sell orders to see real-time trade receipts',
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: orders.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            itemBuilder: (context, index) {
              final order = orders[index];
              final isBuy = order.type == OrderType.buy;
              final badgeBg = isBuy
                  ? (isDark ? Colors.green.shade900.withOpacity(0.4) : AppColors.greenFlash)
                  : (isDark ? Colors.red.shade900.withOpacity(0.4) : AppColors.redFlash);
              final badgeFg = isBuy ? AppColors.greenUp : AppColors.redDown;
              final formattedTime = DateFormat('dd MMM, hh:mm:ss a').format(order.executedAt);

              return Container(
                color: theme.cardColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // BUY / SELL Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        order.type.name.toUpperCase(),
                        style: TextStyle(
                          color: badgeFg,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Stock Details & Timestamp
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                order.symbol,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('EXECUTED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Qty: ${order.quantity} • Exec: ${CurrencyFormatter.format(order.executionPrice)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Total Trade Value
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.format(order.totalValue),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'NSE EQ',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}