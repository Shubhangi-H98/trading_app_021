import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/model/holding_model.dart';
import '../../../data/model/stock_model.dart';

class HoldingTile extends StatelessWidget {
  final HoldingModel holding;
  final StockModel? stock;
  final VoidCallback onTap;

  const HoldingTile({
    super.key,
    required this.holding,
    required this.stock,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ltp = stock?.ltp ?? holding.averageBuyPrice;
    final currentValue = holding.quantity * ltp;
    final totalCost = holding.quantity * holding.averageBuyPrice;
    final pl = currentValue - totalCost;
    final plPercent = totalCost > 0 ? (pl / totalCost) * 100 : 0.0;
    final isProfit = pl >= 0;
    final plColor = isProfit ? AppColors.greenUp : AppColors.redDown;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(
            bottom: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding.symbol,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${holding.quantity} • Avg: ${CurrencyFormatter.format(holding.averageBuyPrice)}',
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isProfit ? '+' : ''}${CurrencyFormatter.format(pl)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: plColor),
                ),
                const SizedBox(height: 4),
                Text(
                  'LTP: ${CurrencyFormatter.format(ltp)} (${isProfit ? '+' : ''}${plPercent.toStringAsFixed(2)}%)',
                  style: TextStyle(fontSize: 12, color: plColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}