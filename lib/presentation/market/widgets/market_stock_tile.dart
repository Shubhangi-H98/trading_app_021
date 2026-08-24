import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/model/stock_model.dart';

class MarketStockTile extends StatefulWidget {
  final StockModel stock;
  final VoidCallback onTap;

  const MarketStockTile({
    super.key,
    required this.stock,
    required this.onTap,
  });

  @override
  State<MarketStockTile> createState() => _MarketStockTileState();
}

class _MarketStockTileState extends State<MarketStockTile> with SingleTickerProviderStateMixin {
  late AnimationController _flashController;
  late Animation<double> _opacityAnimation;
  Color _flashColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant MarketStockTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stock.ltp != oldWidget.stock.ltp) {
      final isUp = widget.stock.ltp > oldWidget.stock.ltp;
      final isDark = Theme.of(context).brightness == Brightness.dark;

      setState(() {
        _flashColor = isUp
            ? (isDark ? Colors.green.shade800.withOpacity(0.5) : AppColors.greenFlash)
            : (isDark ? Colors.red.shade800.withOpacity(0.5) : AppColors.redFlash);
      });

      _flashController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isPositive = widget.stock.change >= 0;
    final changeColor = isPositive ? AppColors.greenUp : AppColors.redDown;

    return Stack(
      children: [
        // Base Tile Container (Clean, compact, instant dark/light theme reaction)
        Container(
          color: theme.cardColor,
          child: ListTile(
            onTap: widget.onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(
              widget.stock.symbol,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            subtitle: Text(
              'NSE EQ',
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontSize: 12,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(widget.stock.ltp),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: changeColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  CurrencyFormatter.formatChange(
                    widget.stock.change,
                    widget.stock.changePercent,
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: changeColor,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Live Ticking Flash Overlay Layer
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                if (_flashController.isDismissed || _opacityAnimation.value == 0) {
                  return const SizedBox.shrink();
                }
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(color: _flashColor),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}