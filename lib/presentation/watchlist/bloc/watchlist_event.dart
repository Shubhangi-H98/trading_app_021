import 'package:equatable/equatable.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();
  @override
  List<Object?> get props => [];
}

class LoadWatchlistsEvent extends WatchlistEvent {}

class CreateWatchlistEvent extends WatchlistEvent {
  final String name;
  const CreateWatchlistEvent(this.name);
  @override
  List<Object?> get props => [name];
}

class RenameWatchlistEvent extends WatchlistEvent {
  final String watchlistId;
  final String newName;
  const RenameWatchlistEvent({required this.watchlistId, required this.newName});
  @override
  List<Object?> get props => [watchlistId, newName];
}

class DeleteWatchlistEvent extends WatchlistEvent {
  final String watchlistId;
  const DeleteWatchlistEvent(this.watchlistId);
  @override
  List<Object?> get props => [watchlistId];
}

class AddStockToWatchlistEvent extends WatchlistEvent {
  final String watchlistId;
  final String symbol;
  const AddStockToWatchlistEvent({required this.watchlistId, required this.symbol});
  @override
  List<Object?> get props => [watchlistId, symbol];
}

class RemoveStockFromWatchlistEvent extends WatchlistEvent {
  final String watchlistId;
  final String symbol;
  const RemoveStockFromWatchlistEvent({required this.watchlistId, required this.symbol});
  @override
  List<Object?> get props => [watchlistId, symbol];
}

class ReorderStocksEvent extends WatchlistEvent {
  final String watchlistId;
  final int oldIndex;
  final int newIndex;
  const ReorderStocksEvent({
    required this.watchlistId,
    required this.oldIndex,
    required this.newIndex,
  });
  @override
  List<Object?> get props => [watchlistId, oldIndex, newIndex];
}