import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/staggered_fade_slide.dart';
import '../../providers/providers.dart';
import '../../data/models/user_model.dart';

class ProfileScreen extends ConsumerWidget {
  final String? uid;

  const ProfileScreen({super.key, this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If no uid provided, show current user's profile
    final isOwnProfile = uid == null || uid == ref.read(userProvider).uid;
    
    if (isOwnProfile) {
      final user = ref.watch(userProvider);
      return _ProfileContent(user: user, isOwnProfile: true);
    }

    final otherUserAsync = ref.watch(otherUserProvider(uid!));

    return otherUserAsync.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('User not found')),
          );
        }
        return _ProfileContent(user: user, isOwnProfile: false);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserModel user;
  final bool isOwnProfile;

  const _ProfileContent({
    required this.user,
    required this.isOwnProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
            title: Text(isOwnProfile ? 'My Profile' : 'Profile', style: AppTypography.headingM),
            centerTitle: true,
            actions: isOwnProfile ? [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push('/settings/edit-profile'),
              ),
            ] : null,
          ),

          // Profile Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar with Glassmorphism shadow
                  Container(
                    width: 120,
                    height: 120,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: user.photoUrl == null ? AppColors.primaryGradient : null,
                        image: user.photoUrl != null
                            ? DecorationImage(
                                image: NetworkImage(user.photoUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: user.photoUrl == null
                          ? Center(
                              child: Text(
                                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                style: AppTypography.headingXL.copyWith(color: Colors.white, fontSize: 48),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(user.name, style: AppTypography.headingL),
                  const SizedBox(height: 4),
                  if (user.bio.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        user.bio,
                        textAlign: TextAlign.center,
                        style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  const SizedBox(height: 16),
                  
                  // Plan Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDeeper.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          user.planBadge,
                          style: AppTypography.captionBold.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stats Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  _buildStatCard('Streak', '${user.streakCount} days', Icons.local_fire_department_rounded, Colors.orange),
                  const SizedBox(width: 12),
                  _buildStatCard('Courses', '${user.enrolledCourses.length}', Icons.auto_stories_rounded, AppColors.primary),
                ],
              ),
            ),
          ),

          // Description Section
          if (user.description.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About', style: AppTypography.headingM),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Text(
                        user.description,
                        style: AppTypography.body.copyWith(height: 1.6, color: AppColors.textPrimary.withValues(alpha: 0.8)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: AppTypography.headingM),
            const SizedBox(height: 2),
            Text(label, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}
