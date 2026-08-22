import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/stock_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';

class AddStockBottomSheet extends StatelessWidget {
  final String watchlistId;
  final List<String> currentSymbols;

  const AddStockBottomSheet({
    super.key,
    required this.watchlistId,
    required this.currentSymbols,
  });

  @override
  Widget build(BuildContext context) {
    final allStocks = StockConstants.symbols;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Stocks to Watchlist',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: allStocks.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final symbol = allStocks[index];
                final isAdded = currentSymbols.contains(symbol);

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('NSE EQ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  trailing: isAdded
                      ? const Chip(
                    label: Text('Added', style: TextStyle(fontSize: 12, color: AppColors.greenUp)),
                    backgroundColor: AppColors.greenFlash,
                  )
                      : IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.primary),
                    onPressed: () {
                      context.read<WatchlistBloc>().add(
                        AddStockToWatchlistEvent(watchlistId: watchlistId, symbol: symbol),
                      );
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}