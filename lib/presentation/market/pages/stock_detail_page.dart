import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../order/widgets/order_ticket_bottom_sheet.dart';
import '../bloc/market_bloc.dart';
import '../bloc/market_state.dart';
import '../widgets/stock_sparkline_chart.dart';

class StockDetailPage extends StatefulWidget {
  final String symbol;

  const StockDetailPage({super.key, required this.symbol});

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  final List<double> _tickHistory = [];
  bool _isHistoryInitialized = false;

  void _initializeHistory(double basePrice, bool isPositive) {
    if (_isHistoryInitialized) return;
    _isHistoryInitialized = true;

    final random = Random();
    double current = isPositive ? basePrice * 0.985 : basePrice * 1.015;

    // Generate realistic prior 20 price trend points
    for (int i = 0; i < 20; i++) {
      final step = (random.nextDouble() - 0.48) * (basePrice * 0.004);
      current = (current + step);
      _tickHistory.add(current);
    }
    _tickHistory.add(basePrice);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<MarketBloc, MarketState>(
      builder: (context, state) {
        final stock = state.stocks[widget.symbol];
        if (stock == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final isPositive = stock.change >= 0;
        final changeColor = isPositive ? AppColors.greenUp : AppColors.redDown;

        // Initialize wave points on first build
        if (!_isHistoryInitialized) {
          _initializeHistory(stock.ltp, isPositive);
        } else if (_tickHistory.isEmpty || _tickHistory.last != stock.ltp) {
          _tickHistory.add(stock.ltp);
          if (_tickHistory.length > 30) _tickHistory.removeAt(0);
        }

        // Simulated market depth stats based on current LTP
        final todayLow = stock.ltp * 0.985;
        final todayHigh = stock.ltp * 1.021;
        final yearLow = stock.ltp * 0.76;
        final yearHigh = stock.ltp * 1.34;
        final simulatedVolume = (stock.ltp * 1420).toInt();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(stock.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
            elevation: 0.5,
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            color: theme.cardColor,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => OrderTicketBottomSheet.show(context, stock.symbol),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenUp,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('BUY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => OrderTicketBottomSheet.show(context, stock.symbol),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redDown,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('SELL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header Price & Change
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        CurrencyFormatter.format(stock.ltp),
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: changeColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${CurrencyFormatter.formatChange(stock.change, stock.changePercent)} • LIVE',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: changeColor),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('NSE EQ • T+1', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Live Waveform Chart Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Live Price Waveform (Tick Stream)',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                    ),
                    const SizedBox(height: 12),
                    StockSparklineChart(
                      priceHistory: _tickHistory,
                      isPositive: isPositive,
                      height: 150,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Performance & Range
              const Text('PERFORMANCE & RANGE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.1)),
              const SizedBox(height: 12),
              _buildRangeBar(context, "Today's Range", todayLow, stock.ltp, todayHigh),
              const SizedBox(height: 16),
              _buildRangeBar(context, "52 Week Range", yearLow, stock.ltp, yearHigh),
              const SizedBox(height: 24),

              // Key Market Stats
              const Text('KEY MARKET STATS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.1)),
              const SizedBox(height: 12),
              _buildStatRow('Volume', NumberFormat.compact().format(simulatedVolume)),
              _buildStatRow('Upper Circuit (5%)', CurrencyFormatter.format(stock.ltp * 1.05)),
              _buildStatRow('Lower Circuit (5%)', CurrencyFormatter.format(stock.ltp * 0.95)),
              _buildStatRow('Lot Size', '1 Share'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRangeBar(BuildContext context, String title, double low, double current, double high) {
    final progress = ((current - low) / (high - low)).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          backgroundColor: Colors.grey.withOpacity(0.2),
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('L: ${CurrencyFormatter.format(low)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            Text('H: ${CurrencyFormatter.format(high)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}