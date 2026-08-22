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

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                  const Text('Invested Value', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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
                  const Text('Current Value', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.format(currentValue),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.divider),
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