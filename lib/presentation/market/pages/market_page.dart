import 'package:flutter/material.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Market', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Market Live Feed (Coming in Step 3)'),
      ),
    );
  }
}