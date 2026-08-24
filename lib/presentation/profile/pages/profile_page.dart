import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Accounts', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 45, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text('Alex Mercer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('alex.mercer@021trade.io', style: TextStyle(color: AppColors.textSecondaryLight)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.greenFlash,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('KYC VERIFIED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.greenUp)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Account Details Section
          _buildSectionHeader('TRADING CREDENTIALS'),
          _buildInfoTile('Client Code (UCC)', '021-TRD8902'),
          _buildInfoTile('Depository (DP ID)', 'IN301549 - NSDL'),
          _buildInfoTile('Segment Authorization', 'NSE - Equity / F&O'),

          const SizedBox(height: 16),
          _buildSectionHeader('BANK & AUTO-PAY'),
          _buildInfoTile('Linked Bank Account', 'HDFC Bank •••• 9812'),
          _buildInfoTile('Account Status', 'Active & Verified'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}