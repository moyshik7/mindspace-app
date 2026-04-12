import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/staggered_fade_slide.dart';
import '../../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final settings = ref.watch(settingsProvider);
    final notificationsEnabled = settings.notificationsEnabled;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Text('Settings', style: AppTypography.headingL),
              ),
            ),

            // Profile card
            SliverToBoxAdapter(
              child: StaggeredFadeSlide(
                index: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: user.photoUrl == null
                                ? AppColors.primaryGradient
                                : null,
                            image: user.photoUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(user.photoUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: user.photoUrl == null
                              ? Center(
                                  child: Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : 'U',
                                    style: AppTypography.headingXL.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name,
                                  style: AppTypography.headingM),
                              const SizedBox(height: 2),
                              Text(
                                user.email,
                                style: AppTypography.caption,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryDeeper
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  user.planBadge,
                                  style: AppTypography.captionBold.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

             // Edit Profile button
            SliverToBoxAdapter(
              child: StaggeredFadeSlide(
                index: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 4),
                  child: OutlinedButton(
                    onPressed: () => context.push('/settings/edit-profile'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Account section
            _buildSection(context, ref, 'Account', [
              _SettingsTile(
                icon: Icons.visibility_outlined,
                title: 'View Profile',
                onTap: () => context.push('/settings/profile'),
              ),
              _SettingsTile(
                icon: Icons.person_outline_rounded,
                title: 'Edit Profile',
                onTap: () => context.push('/settings/edit-profile'),
              ),
              _SettingsTile(
                icon: Icons.link_rounded,
                title: 'Linked Accounts',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'G',
                        style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textMuted, size: 20),
                  ],
                ),
                onTap: () => _showComingSoon(context),
              ),
              _SettingsTile(
                icon: Icons.shield_outlined,
                title: 'Privacy Settings',
                onTap: () => _showComingSoon(context),
              ),
            ], 2),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Subscription section
            _buildSection(context, ref, 'Subscription', [
              _SettingsTile(
                icon: Icons.card_membership_rounded,
                title: 'Current Plan',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.planBadge,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textMuted, size: 20),
                  ],
                ),
                onTap: () => context.push('/settings/paywall'),
              ),
              _SettingsTile(
                icon: Icons.upgrade_rounded,
                title: 'Upgrade Plan',
                onTap: () => context.push('/settings/paywall'),
              ),
              _SettingsTile(
                icon: Icons.restore_rounded,
                title: 'Restore Purchases',
                onTap: () => _showComingSoon(context),
              ),
            ], 3),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // App Settings section
            _buildSection(context, ref, 'App Settings', [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                trailing: Switch(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .toggleNotifications(value);
                  },
                ),
              ),
              _SettingsTile(
                icon: Icons.access_time_rounded,
                title: 'Daily Reminder Time',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${settings.reminderHour % 12 == 0 ? 12 : settings.reminderHour % 12}:${settings.reminderMinute.toString().padLeft(2, '0')} ${settings.reminderHour >= 12 ? 'PM' : 'AM'}',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textMuted, size: 20),
                  ],
                ),
                onTap: () => _pickReminderTime(context, ref, settings),
              ),
              _SettingsTile(
                icon: Icons.language_rounded,
                title: 'Language',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('English',
                        style: AppTypography.caption),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textMuted, size: 20),
                  ],
                ),
                onTap: () => _showComingSoon(context),
              ),
            ], 4),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Support section
            _buildSection(context, ref, 'Support & About', [
              _SettingsTile(
                icon: Icons.help_outline_rounded,
                title: 'Help Center',
                onTap: () => _showComingSoon(context),
              ),
              _SettingsTile(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                onTap: () => context.push('/settings/feedback'),
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () => context.push('/settings/privacy'),
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () => context.push('/settings/tos'),
              ),
              _SettingsTile(
                icon: Icons.star_outline_rounded,
                title: 'Rate the App',
                onTap: () => _showComingSoon(context),
              ),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'App Version',
                trailing: Text(
                  'v1.1.7 (Build 1)',
                  style: AppTypography.caption,
                ),
              ),
            ], 5),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Danger zone
            _buildSection(context, ref, 'Danger Zone', [
              _SettingsTile(
                icon: Icons.logout_rounded,
                title: 'Log Out',
                titleColor: AppColors.error,
                onTap: () => _showLogoutDialog(context, ref),
              ),
              _SettingsTile(
                icon: Icons.delete_forever_rounded,
                title: 'Delete Account',
                titleColor: AppColors.error,
                onTap: () => _showDeleteDialog(context),
              ),
            ], 6),

            SliverToBoxAdapter(
              child: SizedBox(
                  height: 100 + MediaQuery.of(context).padding.bottom),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSection(
    BuildContext context,
    WidgetRef ref,
    String title,
    List<_SettingsTile> tiles,
    int staggerIndex,
  ) {
    return SliverToBoxAdapter(
      child: StaggeredFadeSlide(
        index: staggerIndex,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  title,
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.textMuted,
                    letterSpacing: 0.5,
                    fontSize: 11,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Column(
                  children: List.generate(tiles.length, (index) {
                    final tile = tiles[index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: tile.onTap,
                          borderRadius: BorderRadius.vertical(
                            top: index == 0
                                ? const Radius.circular(16)
                                : Radius.zero,
                            bottom: index == tiles.length - 1
                                ? const Radius.circular(16)
                                : Radius.zero,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Icon(
                                  tile.icon,
                                  size: 20,
                                  color: tile.titleColor ??
                                      AppColors.textSecondary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    tile.title,
                                    style: AppTypography.body.copyWith(
                                      color: tile.titleColor,
                                    ),
                                  ),
                                ),
                                if (tile.trailing != null)
                                  tile.trailing!
                                else if (tile.onTap != null)
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: AppColors.textMuted,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (index < tiles.length - 1)
                          Divider(
                            height: 1,
                            indent: 48,
                            color: AppColors.surfaceBorder
                                .withValues(alpha: 0.5),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon! Stay tuned 🚀')),
    );
  }

  Future<void> _pickReminderTime(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
  ) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settings.reminderHour,
        minute: settings.reminderMinute,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      ref.read(settingsProvider.notifier).setReminderTime(
            pickedTime.hour,
            pickedTime.minute,
          );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reminder time set to ${pickedTime.format(context)}',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authProvider.notifier).signOut();
              context.go('/login');
            },
            child: Text(
              'Log Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action is irreversible. Type "DELETE" to confirm.',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type DELETE',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Please contact support@mindspace.app to delete your account.'),
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.titleColor,
    this.trailing,
    this.onTap,
  });
}
