import 'package:flutter/material.dart';

class HoldingsPage extends StatelessWidget {
  const HoldingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holdings & Portfolio', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Holdings & P&L (Coming in Step 5)'),
      ),
    );
  }
}