import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class StockSparklineChart extends StatelessWidget {
  final List<double> priceHistory;
  final bool isPositive;
  final double height;
  final double width;

  const StockSparklineChart({
    super.key,
    required this.priceHistory,
    required this.isPositive,
    this.height = 40,
    this.width = 80,
  });

  @override
  Widget build(BuildContext context) {
    if (priceHistory.length < 2) {
      return SizedBox(height: height, width: width);
    }

    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(
        painter: _SparklinePainter(
          prices: priceHistory,
          lineColor: isPositive ? AppColors.greenUp : AppColors.redDown,
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> prices;
  final Color lineColor;

  _SparklinePainter({required this.prices, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final range = (maxPrice - minPrice) == 0 ? 1.0 : (maxPrice - minPrice);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withOpacity(0.25),
          lineColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (prices.length - 1);

    for (int i = 0; i < prices.length; i++) {
      final x = i * stepX;
      final normalizedY = (prices[i] - minPrice) / range;
      final y = size.height - (normalizedY * (size.height - 8)) - 4;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) => true;
}