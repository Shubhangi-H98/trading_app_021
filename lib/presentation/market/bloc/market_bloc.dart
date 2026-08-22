import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/mock_market_feed_service.dart';
import 'market_event.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final MockMarketFeedService _feedService;
  StreamSubscription? _feedSubscription;

  MarketBloc(this._feedService) : super(const MarketState()) {
    on<StartMarketFeedEvent>(_onStartFeed);
    on<MarketPricesUpdatedEvent>(_onPricesUpdated);
    on<ChangeTickRateEvent>(_onChangeTickRate);
  }

  void _onStartFeed(StartMarketFeedEvent event, Emitter<MarketState> emit) {
    _feedService.initialize();
    emit(state.copyWith(status: MarketStatus.live, stocks: _feedService.currentPrices));

    _feedSubscription?.cancel();
    _feedSubscription = _feedService.priceStream.listen((stocks) {
      add(MarketPricesUpdatedEvent(stocks));
    });
  }

  void _onPricesUpdated(MarketPricesUpdatedEvent event, Emitter<MarketState> emit) {
    emit(state.copyWith(stocks: event.stocks));
  }

  void _onChangeTickRate(ChangeTickRateEvent event, Emitter<MarketState> emit) {
    _feedService.setTickRate(event.tickRate);
    emit(state.copyWith(tickRate: event.tickRate));
  }

  @override
  Future<void> close() {
    _feedSubscription?.cancel();
    return super.close();
  }
}