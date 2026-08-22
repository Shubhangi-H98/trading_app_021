import 'package:flutter/material.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Watchlist Screen (Coming in Step 4)'),
      ),
    );
  }
}