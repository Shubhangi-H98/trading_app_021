import 'package:equatable/equatable.dart';

import '../../../data/model/watchlist_model.dart';


enum WatchlistStatus { initial, loading, loaded, error }

class WatchlistState extends Equatable {
  final WatchlistStatus status;
  final List<WatchlistModel> watchlists;
  final String? errorMessage;

  const WatchlistState({
    this.status = WatchlistStatus.initial,
    this.watchlists = const [],
    this.errorMessage,
  });

  WatchlistState copyWith({
    WatchlistStatus? status,
    List<WatchlistModel>? watchlists,
    String? errorMessage,
  }) {
    return WatchlistState(
      status: status ?? this.status,
      watchlists: watchlists ?? this.watchlists,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, watchlists, errorMessage];
}