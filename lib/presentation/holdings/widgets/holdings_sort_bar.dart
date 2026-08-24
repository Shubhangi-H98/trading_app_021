import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/portfolio_bloc.dart';
import '../bloc/portfolio_event.dart';
import '../bloc/portfolio_state.dart';

class HoldingsSortBar extends StatelessWidget {
  const HoldingsSortBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<PortfolioBloc, PortfolioState>(
      buildWhen: (prev, curr) => prev.sortCriteria != curr.sortCriteria,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).cardColor,
          child: Row(
            children: [
              Text(
                'Sort by:',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(width: 8),
              _buildChip(context, 'P&L', HoldingSortCriteria.pl, state.sortCriteria, isDark),
              const SizedBox(width: 8),
              _buildChip(context, 'Symbol', HoldingSortCriteria.symbol, state.sortCriteria, isDark),
              const SizedBox(width: 8),
              _buildChip(context, 'Value', HoldingSortCriteria.currentValue, state.sortCriteria, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(
      BuildContext context,
      String label,
      HoldingSortCriteria criteria,
      HoldingSortCriteria current,
      bool isDark,
      ) {
    final isSelected = criteria == current;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade100,
      showCheckmark: false,
      padding: EdgeInsets.zero,
      onSelected: (_) {
        context.read<PortfolioBloc>().add(SortHoldingsEvent(criteria));
      },
    );
  }
}