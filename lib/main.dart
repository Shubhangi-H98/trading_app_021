import 'package:flutter/material.dart';
import 'package:trading_app_021/presentation/splash/splash_page.dart';
import 'core/theme/app_theme.dart';


void main() {
  runApp(const TradingApp());
}

class TradingApp extends StatelessWidget {
  const TradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
    );
  }
}