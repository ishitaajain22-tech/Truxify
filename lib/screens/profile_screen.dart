import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_page_route.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context, String title) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('This area is mocked for now.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: FreightFairColors.secondaryText)),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Close', onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = FreightFairScope.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [FreightFairColors.accent, FreightFairColors.accentDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.14), shape: BoxShape.circle),
                      child: const Center(child: Text(mockInitials, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800))),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () => _showComingSoon(context, 'Edit Profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70),
                        minimumSize: const Size(0, 42),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(mockCustomerName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(mockCompanyName, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                const SizedBox(height: 4),
                Text(mockPhoneNumber, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
              ],
            ),
          ),
          const SizedBox(height: 18),
          InfoCard(
            child: Column(
              children: mockProfileMenu.map((item) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(item.icon, color: item.isDanger ? FreightFairColors.error : FreightFairColors.accentDark),
                      title: Text(
                        item.title,
                        style: TextStyle(fontWeight: FontWeight.w700, color: item.isDanger ? FreightFairColors.error : FreightFairColors.primaryText),
                      ),
                      subtitle: item.subtitle == null ? null : Text(item.subtitle!, style: const TextStyle(color: FreightFairColors.secondaryText)),
                      trailing: item.isDanger ? null : const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        if (item.title == 'Order History') {
                          controller.openOrders(tabIndex: 1);
                        } else if (item.title == 'Logout') {
                          Navigator.of(context).pushAndRemoveUntil(
                            AppPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        } else {
                          _showComingSoon(context, item.title);
                        }
                      },
                    ),
                    if (item != mockProfileMenu.last) const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),
          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Member since', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: FreightFairColors.secondaryText)),
                const SizedBox(height: 4),
                Text('Jan 2024', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text('Total orders', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: FreightFairColors.secondaryText)),
                const SizedBox(height: 4),
                Text('28', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text('Total saved vs broker', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: FreightFairColors.secondaryText)),
                const SizedBox(height: 4),
                Text('₹42,800', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text('CO2 saved (empty trips eliminated)', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: FreightFairColors.secondaryText)),
                const SizedBox(height: 4),
                Text('124 kg 🌱', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
