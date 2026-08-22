import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/portfolio_bloc.dart';
import '../bloc/portfolio_event.dart  Dart.dart';
import '../bloc/portfolio_state.dart';

class HoldingsSortBar extends StatelessWidget {
  const HoldingsSortBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      buildWhen: (prev, curr) => prev.sortCriteria != curr.sortCriteria,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            children: [
              const Text('Sort by:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: 8),
              _buildChip(context, 'P&L', HoldingSortCriteria.pl, state.sortCriteria),
              const SizedBox(width: 8),
              _buildChip(context, 'Symbol', HoldingSortCriteria.symbol, state.sortCriteria),
              const SizedBox(width: 8),
              _buildChip(context, 'Value', HoldingSortCriteria.currentValue, state.sortCriteria),
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
      ) {
    final isSelected = criteria == current;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black87)),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.grey.shade100,
      showCheckmark: false,
      padding: EdgeInsets.zero,
      onSelected: (_) {
        context.read<PortfolioBloc>().add(SortHoldingsEvent(criteria));
      },
    );
  }
}