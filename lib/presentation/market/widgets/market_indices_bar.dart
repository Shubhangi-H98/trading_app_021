import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../bloc/market_bloc.dart';
import '../bloc/market_state.dart';

class MarketIndicesBar extends StatelessWidget {
  const MarketIndicesBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<MarketBloc, MarketState>(
      builder: (context, state) {
        // Derive overall market drift from state stocks
        double totalChangePercent = 0.0;
        if (state.stocks.isNotEmpty) {
          totalChangePercent = state.stocks.values
              .map((s) => s.changePercent)
              .reduce((a, b) => a + b) /
              state.stocks.length;
        }

        // Realistic benchmark index calculations
        final niftyBase = 24450.0;
        final niftyLtp = niftyBase * (1 + (totalChangePercent / 100));
        final niftyChange = niftyLtp - niftyBase;

        final sensexBase = 80100.0;
        final sensexLtp = sensexBase * (1 + (totalChangePercent / 100));
        final sensexChange = sensexLtp - sensexBase;

        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _buildIndexChip(
                  title: 'NIFTY 50',
                  ltp: niftyLtp,
                  change: niftyChange,
                  percent: totalChangePercent,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildIndexChip(
                  title: 'SENSEX',
                  ltp: sensexLtp,
                  change: sensexChange,
                  percent: totalChangePercent,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIndexChip({
    required String title,
    required double ltp,
    required double change,
    required double percent,
    required bool isDark,
  }) {
    final isPositive = percent >= 0;
    final color = isPositive ? AppColors.greenUp : AppColors.redDown;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade300,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondaryLight,
                  letterSpacing: 0.3,
                ),
              ),
              Flexible(
                child: Text(
                  '${isPositive ? '+' : ''}${percent.toStringAsFixed(2)}%',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CurrencyFormatter.format(ltp),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Flexible(
                child: Text(
                  '${isPositive ? '+' : ''}${change.toStringAsFixed(1)}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}