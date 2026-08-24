import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/model/watchlist_model.dart';
import '../../dashboard/widgets/app_side_drawer.dart';
import '../../market/bloc/market_bloc.dart';
import '../../market/bloc/market_state.dart';
import '../../market/pages/stock_detail_page.dart';
import '../../market/widgets/market_stock_tile.dart';
import '../../order/widgets/order_ticket_bottom_sheet.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
import '../widgets/add_stock_bottom_sheet.dart';
import '../widgets/create_watchlist_dialog.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, watchlistState) {
        if (watchlistState.status == WatchlistStatus.loading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final watchlists = watchlistState.watchlists;

        if (watchlists.isEmpty) {
          return Scaffold(
            drawer: const AppSideDrawer(),
            appBar: AppBar(
              leading: Builder(
                builder: (innerContext) => IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: 'Open Menu',
                  onPressed: () => Scaffold.of(innerContext).openDrawer(),
                ),
              ),
              title: const Text('Watchlist', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_border, size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  const Text('No Watchlist found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _openCreateDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Watchlist'),
                  ),
                ],
              ),
            ),
          );
        }

        return DefaultTabController(
          length: watchlists.length,
          child: Scaffold(
            drawer: const AppSideDrawer(),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              leading: Builder(
                builder: (innerContext) => IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: 'Open Menu',
                  onPressed: () => Scaffold.of(innerContext).openDrawer(),
                ),
              ),
              title: const Text('Watchlists', style: TextStyle(fontWeight: FontWeight.bold)),
              elevation: 0.5,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Create Watchlist',
                  onPressed: () => _openCreateDialog(context),
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: watchlists.map((w) => Tab(text: w.name)).toList(),
              ),
            ),
            body: TabBarView(
              children: watchlists.map((watchlist) {
                return _WatchlistContentView(watchlist: watchlist);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _openCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CreateWatchlistDialog(
        onSave: (name) {
          context.read<WatchlistBloc>().add(CreateWatchlistEvent(name));
        },
      ),
    );
  }
}

class _WatchlistContentView extends StatelessWidget {
  final WatchlistModel watchlist;

  const _WatchlistContentView({required this.watchlist});

  @override
  Widget build(BuildContext context) {
    final List<String> symbols = watchlist.stockSymbols;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).cardColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${symbols.length} Stocks',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    tooltip: 'Rename',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => CreateWatchlistDialog(
                          initialName: watchlist.name,
                          onSave: (newName) {
                            context.read<WatchlistBloc>().add(
                              RenameWatchlistEvent(watchlistId: watchlist.id, newName: newName),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.redDown),
                    tooltip: 'Delete',
                    onPressed: () {
                      context.read<WatchlistBloc>().add(DeleteWatchlistEvent(watchlist.id));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.primary),
                    tooltip: 'Add Stock',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => AddStockBottomSheet(
                          watchlistId: watchlist.id,
                          currentSymbols: symbols,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
        Expanded(
          child: symbols.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_chart, size: 48, color: AppColors.textMuted),
                const SizedBox(height: 8),
                const Text('No stocks in this watchlist'),
                TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => AddStockBottomSheet(
                        watchlistId: watchlist.id,
                        currentSymbols: symbols,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Stock'),
                ),
              ],
            ),
          )
              : BlocBuilder<MarketBloc, MarketState>(
            builder: (context, marketState) {
              return ReorderableListView.builder(
                itemCount: symbols.length,
                onReorder: (oldIndex, newIndex) {
                  context.read<WatchlistBloc>().add(
                    ReorderStocksEvent(
                      watchlistId: watchlist.id,
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  final symbol = symbols[index];
                  final stock = marketState.stocks[symbol];

                  if (stock == null) return const SizedBox.shrink(key: ValueKey('empty'));

                  return Dismissible(
                    key: ValueKey('dismiss_$symbol'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: AppColors.redDown,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      context.read<WatchlistBloc>().add(
                        RemoveStockFromWatchlistEvent(
                          watchlistId: watchlist.id,
                          symbol: symbol,
                        ),
                      );
                    },
                    child: MarketStockTile(
                      key: ValueKey(symbol),
                      stock: stock,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StockDetailPage(symbol: symbol),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}