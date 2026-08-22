class StockConstants {
  static const Map<String, double> initialStockPrices = {
    'RELIANCE': 2950.00,
    'TCS': 3820.50,
    'INFY': 1610.75,
    'HDFCBANK': 1530.20,
    'ICICIBANK': 1110.00,
    'SBIN': 815.40,
    'ITC': 495.60,
    'LT': 3620.00,
    'BHARTIARTL': 1480.30,
    'AXISBANK': 1175.80,
  };

  static List<String> get symbols => initialStockPrices.keys.toList();
}