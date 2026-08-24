import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../holdings/bloc/portfolio_bloc.dart';
import '../../holdings/bloc/portfolio_state.dart';
import '../../login/login_screen.dart';
import '../../profile/pages/profile_page.dart';

class AppSideDrawer extends StatelessWidget {
  const AppSideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Column(
        children: [
          // User Account Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'TA',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
            accountName: const Text(
              'Trader Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: const Text('ucc: 021-TRD8902 • Active Pro Trader'),
          ),

          // Virtual Wallet Funds Card
          BlocBuilder<PortfolioBloc, PortfolioState>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Available Funds', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(state.walletBalance),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.account_balance_wallet, color: AppColors.primary),
                      tooltip: 'Virtual Wallet',
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(),

          // Menu Options
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('User Profile & KYC'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Tradebook & Orders'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Viewing latest 50 executed trade transactions')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.security_outlined),
            title: const Text('Security & Biometrics'),
            trailing: const Chip(label: Text('Enabled', style: TextStyle(fontSize: 10, color: AppColors.greenUp))),
            onTap: () {},
          ),

          // Dark Theme Toggle Switch
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDarkMode = themeMode == ThemeMode.dark;
              return SwitchListTile(
                secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                title: const Text('Dark Mode'),
                value: isDarkMode,
                onChanged: (_) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),

          const Spacer(),
          const Divider(),

          // Logout Flow
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.redDown),
            title: const Text('Logout', style: TextStyle(color: AppColors.redDown, fontWeight: FontWeight.bold)),
            onTap: () => _confirmLogout(context),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to end your active trading session?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.redDown),
            onPressed: () {
              Navigator.pop(dialogCtx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}