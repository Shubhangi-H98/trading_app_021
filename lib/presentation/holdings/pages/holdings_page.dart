import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/model/holding_model.dart';
import '../../market/bloc/market_bloc.dart';
import '../../market/bloc/market_state.dart';
import '../../market/pages/stock_detail_page.dart';
import '../../order/widgets/order_ticket_bottom_sheet.dart';
import '../bloc/portfolio_bloc.dart';
import '../bloc/portfolio_event.dart';
import '../bloc/portfolio_state.dart';
import '../widgets/holding_tile.dart';
import '../widgets/holdings_sort_bar.dart';
import '../widgets/holdings_summary_card.dart';

class HoldingsPage extends StatelessWidget {
  const HoldingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Holdings & Portfolio', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0.5,
        actions: [
          BlocBuilder<PortfolioBloc, PortfolioState>(
            buildWhen: (prev, curr) => prev.walletBalance != curr.walletBalance,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    'Funds: ${CurrencyFormatter.format(state.walletBalance)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, portfolioState) {
          final holdings = portfolioState.holdings;

          if (holdings.isEmpty) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 64,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                  ),
                  const SizedBox(height: 12),
                  const Text('No active holdings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'Place a Buy order from Watchlist to see your portfolio',
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }

          return BlocBuilder<MarketBloc, MarketState>(
            builder: (context, marketState) {
              // Calculate Aggregates
              double totalInvested = 0.0;
              double totalCurrentValue = 0.0;

              for (final h in holdings) {
                final ltp = marketState.stocks[h.symbol]?.ltp ?? h.averageBuyPrice;
                totalInvested += (h.quantity * h.averageBuyPrice);
                totalCurrentValue += (h.quantity * ltp);
              }

              final totalPl = totalCurrentValue - totalInvested;
              final totalPlPercent = totalInvested > 0 ? (totalPl / totalInvested) * 100 : 0.0;

              // Sort Holdings
              final sortedHoldings = List<HoldingModel>.from(holdings);
              switch (portfolioState.sortCriteria) {
                case HoldingSortCriteria.pl:
                  sortedHoldings.sort((a, b) {
                    final ltpA = marketState.stocks[a.symbol]?.ltp ?? a.averageBuyPrice;
                    final ltpB = marketState.stocks[b.symbol]?.ltp ?? b.averageBuyPrice;
                    final plA = (a.quantity * ltpA) - (a.quantity * a.averageBuyPrice);
                    final plB = (b.quantity * ltpB) - (b.quantity * b.averageBuyPrice);
                    return plB.compareTo(plA); // Highest profit first
                  });
                  break;
                case HoldingSortCriteria.symbol:
                  sortedHoldings.sort((a, b) => a.symbol.compareTo(b.symbol));
                  break;
                case HoldingSortCriteria.currentValue:
                  sortedHoldings.sort((a, b) {
                    final valA = a.quantity * (marketState.stocks[a.symbol]?.ltp ?? a.averageBuyPrice);
                    final valB = b.quantity * (marketState.stocks[b.symbol]?.ltp ?? b.averageBuyPrice);
                    return valB.compareTo(valA);
                  });
                  break;
              }

              return Column(
                children: [
                  HoldingsSummaryCard(
                    totalInvested: totalInvested,
                    currentValue: totalCurrentValue,
                    totalPl: totalPl,
                    totalPlPercent: totalPlPercent,
                  ),
                  const HoldingsSortBar(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sortedHoldings.length,
                      itemBuilder: (context, index) {
                        final holding = sortedHoldings[index];
                        final stock = marketState.stocks[holding.symbol];

                        return HoldingTile(
                          holding: holding,
                          stock: stock,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StockDetailPage(symbol: holding.symbol),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}