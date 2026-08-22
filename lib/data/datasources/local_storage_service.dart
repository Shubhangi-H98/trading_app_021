import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/holding_model.dart';
import '../model/order_model.dart';
import '../model/watchlist_model.dart';

class LocalStorageService {
  static const _keyWatchlists = 'key_watchlists';
  static const _keyHoldings = 'key_holdings';
  static const _keyOrders = 'key_orders';
  static const _keyWalletBalance = 'key_wallet_balance';

  static const double initialWalletBalance = 500000.0; // ₹5,00,000 default virtual balance

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // --- Watchlists Persistence ---
  List<WatchlistModel> getWatchlists() {
    final raw = _prefs.getString(_keyWatchlists);
    if (raw == null) return _defaultWatchlists();
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((e) => WatchlistModel.fromJson(e)).toList();
  }

  Future<void> saveWatchlists(List<WatchlistModel> watchlists) async {
    final raw = jsonEncode(watchlists.map((w) => w.toJson()).toList());
    await _prefs.setString(_keyWatchlists, raw);
  }

  // --- Holdings Persistence ---
  List<HoldingModel> getHoldings() {
    final raw = _prefs.getString(_keyHoldings);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((e) => HoldingModel.fromJson(e)).toList();
  }

  Future<void> saveHoldings(List<HoldingModel> holdings) async {
    final raw = jsonEncode(holdings.map((h) => h.toJson()).toList());
    await _prefs.setString(_keyHoldings, raw);
  }

  // --- Wallet Balance Persistence ---
  double getWalletBalance() {
    return _prefs.getDouble(_keyWalletBalance) ?? initialWalletBalance;
  }

  Future<void> saveWalletBalance(double balance) async {
    await _prefs.setDouble(_keyWalletBalance, balance);
  }

  // --- Order History Persistence ---
  List<OrderModel> getOrders() {
    final raw = _prefs.getString(_keyOrders);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<void> saveOrder(OrderModel order) async {
    final orders = getOrders()..insert(0, order);
    final raw = jsonEncode(orders.map((o) => o.toJson()).toList());
    await _prefs.setString(_keyOrders, raw);
  }

  // Default seed data for initial start
  List<WatchlistModel> _defaultWatchlists() {
    return const [
      WatchlistModel(
        id: '1',
        name: 'NIFTY Top',
        stockSymbols: ['RELIANCE', 'TCS', 'INFY', 'HDFCBANK', 'ICICIBANK'],
      ),
      WatchlistModel(
        id: '2',
        name: 'Banking & FMCG',
        stockSymbols: ['SBIN', 'ITC', 'LT', 'BHARTIARTL', 'AXISBANK'],
      ),
    ];
  }
}