import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local_storage_service.dart';
import 'data/datasources/mock_market_feed_service.dart';
import 'presentation/market/bloc/market_bloc.dart';
import 'presentation/market/bloc/market_event.dart';
import 'presentation/splash/splash_page.dart';
import 'presentation/watchlist/bloc/watchlist_bloc.dart';
import 'presentation/watchlist/bloc/watchlist_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localStorageService = LocalStorageService(prefs);

  runApp(TradingApp(localStorageService: localStorageService));
}

class TradingApp extends StatelessWidget {
  final LocalStorageService localStorageService;

  const TradingApp({super.key, required this.localStorageService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MarketBloc(MockMarketFeedService())..add(StartMarketFeedEvent()),
        ),
        BlocProvider(
          create: (_) => WatchlistBloc(localStorageService)..add(LoadWatchlistsEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}