import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../holdings/pages/holdings_page.dart';
import '../market/pages/market_page.dart';
import '../order/pages/orders_page.dart';
import '../watchlist/pages/watchlist_page.dart';
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    WatchlistPage(),
    OrdersPage(),
    MarketPage(),
    HoldingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: theme.cardColor,
        indicatorColor: AppColors.primary.withOpacity(isDark ? 0.3 : 0.12),
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark, color: AppColors.primary),
            label: 'Watchlist',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: AppColors.primary),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart, color: AppColors.primary),
            label: 'Market',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet, color: AppColors.primary),
            label: 'Holdings',
          ),
        ],
      ),
    );
  }
}