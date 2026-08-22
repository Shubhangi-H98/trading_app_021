import 'dart:async';
import 'dart:math';
import '../../core/constants/stock_constants.dart';
import '../model/stock_model.dart';

class MockMarketFeedService {
  static final MockMarketFeedService _instance = MockMarketFeedService._internal();
  factory MockMarketFeedService() => _instance;
  MockMarketFeedService._internal();

  final _random = Random();
  final Map<String, StockModel> _stocks = {};

  // Broadcast stream so multiple widgets/blocs can listen together
  final StreamController<Map<String, StockModel>> _feedController =
  StreamController<Map<String, StockModel>>.broadcast();

  Stream<Map<String, StockModel>> get priceStream => _feedController.stream;
  Map<String, StockModel> get currentPrices => Map.unmodifiable(_stocks);

  Timer? _timer;
  int _ticksPerSecond = 2; // Default 2 ticks per second

  void initialize() {
    if (_stocks.isNotEmpty) return;

    for (final entry in StockConstants.initialStockPrices.entries) {
      _stocks[entry.key] = StockModel(
        symbol: entry.key,
        ltp: entry.value,
        previousClose: entry.value,
        change: 0.0,
        changePercent: 0.0,
        direction: PriceDirection.unchanged,
        lastUpdated: DateTime.now(),
      );
    }
    _feedController.add(_stocks);
    startFeed();
  }

  void setTickRate(int ticksPerSec) {
    _ticksPerSecond = ticksPerSec.clamp(1, 50);
    startFeed();
  }

  void startFeed() {
    _timer?.cancel();
    final intervalMs = (1000 / _ticksPerSecond).round();

    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      _generateNextTick();
    });
  }

  void _generateNextTick() {
    if (_stocks.isEmpty) return;

    // Pick 1 or 2 random stocks per tick
    final symbols = _stocks.keys.toList();
    final pickedSymbol = symbols[_random.nextInt(symbols.length)];
    final current = _stocks[pickedSymbol]!;

    // Random fluctuation between -1.5% to +1.5%
    final percentChange = (_random.nextDouble() * 3.0 - 1.5) / 100.0;
    final priceDiff = current.ltp * percentChange;
    final newLtp = double.parse((current.ltp + priceDiff).toStringAsFixed(2));

    final totalChange = double.parse((newLtp - current.previousClose).toStringAsFixed(2));
    final totalChangePercent =
    double.parse(((totalChange / current.previousClose) * 100).toStringAsFixed(2));

    PriceDirection dir = PriceDirection.unchanged;
    if (newLtp > current.ltp) {
      dir = PriceDirection.up;
    } else if (newLtp < current.ltp) {
      dir = PriceDirection.down;
    }

    _stocks[pickedSymbol] = current.copyWith(
      ltp: newLtp,
      change: totalChange,
      changePercent: totalChangePercent,
      direction: dir,
      lastUpdated: DateTime.now(),
    );

    _feedController.add(Map.from(_stocks));
  }

  void dispose() {
    _timer?.cancel();
    _feedController.close();
  }
}