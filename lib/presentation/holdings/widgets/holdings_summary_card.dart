import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';

class HoldingsSummaryCard extends StatelessWidget {
  final double totalInvested;
  final double currentValue;
  final double totalPl;
  final double totalPlPercent;

  const HoldingsSummaryCard({
    super.key,
    required this.totalInvested,
    required this.currentValue,
    required this.totalPl,
    required this.totalPlPercent,
  });

  @override
  Widget build(BuildContext context) {
    final isProfit = totalPl >= 0;
    final plColor = isProfit ? AppColors.greenUp : AppColors.redDown;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invested Value',
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.format(totalInvested),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Current Value',
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.format(currentValue),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            height: 24,
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total P&L', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Text(
                '${isProfit ? '+' : ''}${CurrencyFormatter.format(totalPl)} (${isProfit ? '+' : ''}${totalPlPercent.toStringAsFixed(2)}%)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: plColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}