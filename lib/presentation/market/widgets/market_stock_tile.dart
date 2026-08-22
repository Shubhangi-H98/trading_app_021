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
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.white,
    ).animate(_flashController);
  }

  @override
  void didUpdateWidget(covariant MarketStockTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stock.ltp != oldWidget.stock.ltp) {
      final isUp = widget.stock.ltp > oldWidget.stock.ltp;
      _colorAnimation = ColorTween(
        begin: isUp ? AppColors.greenFlash : AppColors.redFlash,
        end: Colors.white,
      ).animate(_flashController);

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
    final isPositive = widget.stock.change >= 0;
    final changeColor = isPositive ? AppColors.greenUp : AppColors.redDown;

    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          color: _colorAnimation.value,
          child: ListTile(
            onTap: widget.onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(
              widget.stock.symbol,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              'NSE EQ',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
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
        );
      },
    );
  }
}