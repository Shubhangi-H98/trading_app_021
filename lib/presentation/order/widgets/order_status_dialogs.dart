import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/feedback_helper.dart';
import '../../holdings/bloc/portfolio_bloc.dart';
import '../../holdings/bloc/portfolio_event.dart';

class OrderSuccessDialog extends StatefulWidget {
  final String symbol;
  final String side;
  final int quantity;
  final double price;

  const OrderSuccessDialog({
    super.key,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
  });

  static void show(
      BuildContext context, {
        required String symbol,
        required String side,
        required int quantity,
        required double price,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => OrderSuccessDialog(
        symbol: symbol,
        side: side,
        quantity: quantity,
        price: price,
      ),
    );
  }

  @override
  State<OrderSuccessDialog> createState() => _OrderSuccessDialogState();
}

class _OrderSuccessDialogState extends State<OrderSuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();

    // Auto-close in 1.5 seconds
    _autoCloseTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isBuy = widget.side.toUpperCase() == 'BUY';

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: isBuy
                        ? AppColors.greenUp.withOpacity(0.15)
                        : AppColors.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 52,
                    color: isBuy ? AppColors.greenUp : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Order Executed!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                '${widget.side.toUpperCase()} ${widget.quantity} • ${widget.symbol}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Avg. Price ${CurrencyFormatter.format(widget.price)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isBuy ? AppColors.greenUp : AppColors.redDown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddFundsQuickModal extends StatelessWidget {
  const AddFundsQuickModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddFundsQuickModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amounts = [10000.0, 25000.0, 50000.0, 100000.0];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Instant Trading Funds',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Quickly top up your simulated wallet to continue placing trades.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: amounts.map((amount) {
              return ElevatedButton(
                onPressed: () {
                  FeedbackHelper.lightClick();
                  context.read<PortfolioBloc>().add(AddFundsEvent(amount));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${CurrencyFormatter.format(amount)} added to wallet successfully!'),
                      backgroundColor: AppColors.greenUp,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.cardColor,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  '+ ${CurrencyFormatter.format(amount)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}