import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/market_bloc.dart';
import '../bloc/market_event.dart';
import '../bloc/market_state.dart';
import '../widgets/market_stock_tile.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live Market', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          // Stress Test Speed Controller Sheet
          IconButton(
            icon: const Icon(Icons.speed),
            tooltip: 'Stress Test Tick Rate',
            onPressed: () => _showTickRateSheet(context),
          ),
        ],
      ),
      body: BlocBuilder<MarketBloc, MarketState>(
        builder: (context, state) {
          if (state.stocks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final stockList = state.stocks.values.toList();

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: stockList.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border),
            itemBuilder: (context, index) {
              final stock = stockList[index];
              return MarketStockTile(
                stock: stock,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Selected ${stock.symbol} (Order ticket opens here)'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showTickRateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return BlocBuilder<MarketBloc, MarketState>(
          bloc: BlocProvider.of<MarketBloc>(context),
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stress Test Speed Control',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Current Rate: ${state.tickRate} ticks/sec',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                  Slider(
                    value: state.tickRate.toDouble(),
                    min: 1,
                    max: 50,
                    divisions: 49,
                    label: '${state.tickRate} ticks/sec',
                    onChanged: (value) {
                      BlocProvider.of<MarketBloc>(context).add(
                        ChangeTickRateEvent(value.round()),
                      );
                    },
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