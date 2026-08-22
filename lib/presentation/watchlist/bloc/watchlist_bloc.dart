import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/local_storage_service.dart';
import '../../../data/model/watchlist_model.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final LocalStorageService _storageService;

  WatchlistBloc(this._storageService) : super(const WatchlistState()) {
    on<LoadWatchlistsEvent>(_onLoadWatchlists);
    on<CreateWatchlistEvent>(_onCreateWatchlist);
    on<RenameWatchlistEvent>(_onRenameWatchlist);
    on<DeleteWatchlistEvent>(_onDeleteWatchlist);
    on<AddStockToWatchlistEvent>(_onAddStock);
    on<RemoveStockFromWatchlistEvent>(_onRemoveStock);
    on<ReorderStocksEvent>(_onReorderStocks);
  }

  void _onLoadWatchlists(LoadWatchlistsEvent event, Emitter<WatchlistState> emit) {
    emit(state.copyWith(status: WatchlistStatus.loading));
    final list = _storageService.getWatchlists();
    emit(state.copyWith(status: WatchlistStatus.loaded, watchlists: list));
  }

  Future<void> _onCreateWatchlist(CreateWatchlistEvent event, Emitter<WatchlistState> emit) async {
    final newWatchlist = WatchlistModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: event.name.trim(),
      stockSymbols: const [],
    );
    final updated = List<WatchlistModel>.from(state.watchlists)..add(newWatchlist);
    await _storageService.saveWatchlists(updated);
    emit(state.copyWith(watchlists: updated));
  }

  Future<void> _onRenameWatchlist(RenameWatchlistEvent event, Emitter<WatchlistState> emit) async {
    final updated = state.watchlists.map((w) {
      if (w.id == event.watchlistId) {
        return w.copyWith(name: event.newName.trim());
      }
      return w;
    }).toList();
    await _storageService.saveWatchlists(updated);
    emit(state.copyWith(watchlists: updated));
  }

  Future<void> _onDeleteWatchlist(DeleteWatchlistEvent event, Emitter<WatchlistState> emit) async {
    final updated = state.watchlists.where((w) => w.id != event.watchlistId).toList();
    await _storageService.saveWatchlists(updated);
    emit(state.copyWith(watchlists: updated));
  }

  Future<void> _onAddStock(AddStockToWatchlistEvent event, Emitter<WatchlistState> emit) async {
    final updated = state.watchlists.map((w) {
      if (w.id == event.watchlistId) {
        if (!w.stockSymbols.contains(event.symbol)) {
          return w.copyWith(stockSymbols: [...w.stockSymbols, event.symbol]);
        }
      }
      return w;
    }).toList();
    await _storageService.saveWatchlists(updated);
    emit(state.copyWith(watchlists: updated));
  }

  Future<void> _onRemoveStock(RemoveStockFromWatchlistEvent event, Emitter<WatchlistState> emit) async {
    final updated = state.watchlists.map((w) {
      if (w.id == event.watchlistId) {
        final filtered = w.stockSymbols.where((s) => s != event.symbol).toList();
        return w.copyWith(stockSymbols: filtered);
      }
      return w;
    }).toList();
    await _storageService.saveWatchlists(updated);
    emit(state.copyWith(watchlists: updated));
  }

  Future<void> _onReorderStocks(ReorderStocksEvent event, Emitter<WatchlistState> emit) async {
    final updated = state.watchlists.map((w) {
      if (w.id == event.watchlistId) {
        final list = List<String>.from(w.stockSymbols);
        int newIdx = event.newIndex;
        if (event.oldIndex < newIdx) {
          newIdx -= 1;
        }
        final item = list.removeAt(event.oldIndex);
        list.insert(newIdx, item);
        return w.copyWith(stockSymbols: list);
      }
      return w;
    }).toList();
    await _storageService.saveWatchlists(updated);
    emit(state.copyWith(watchlists: updated));
  }
}