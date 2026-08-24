import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trading_app_021/presentation/holdings/bloc/portfolio_event.dart%20%20Dart.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'data/datasources/local_storage_service.dart';
import 'data/datasources/mock_market_feed_service.dart';
import 'presentation/holdings/bloc/portfolio_bloc.dart';
import 'presentation/market/bloc/market_bloc.dart';
import 'presentation/market/bloc/market_event.dart';
import 'presentation/splash/splash_page.dart';
import 'presentation/watchlist/bloc/watchlist_bloc.dart';
import 'presentation/watchlist/bloc/watchlist_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localStorageService = LocalStorageService(prefs);

  runApp(TradingApp(
    localStorageService: localStorageService,
    prefs: prefs,
  ));
}

class TradingApp extends StatelessWidget {
  final LocalStorageService localStorageService;
  final SharedPreferences prefs;

  const TradingApp({
    super.key,
    required this.localStorageService,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(prefs)),
        BlocProvider(
          create: (_) => MarketBloc(MockMarketFeedService())..add(StartMarketFeedEvent()),
        ),
        BlocProvider(
          create: (_) => WatchlistBloc(localStorageService)..add(LoadWatchlistsEvent()),
        ),
        BlocProvider(
          create: (_) => PortfolioBloc(localStorageService)..add(LoadPortfolioEvent()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}