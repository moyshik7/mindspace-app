import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/staggered_fade_slide.dart';
import '../../data/dummy_data.dart';
import '../../providers/providers.dart';
import 'widgets/consultation_header.dart';
import 'widgets/talk_with_mehrin_card.dart';
import 'widgets/streak_card.dart';
import 'widgets/plan_banner.dart';
import 'widgets/daily_tip_card.dart';
import 'widgets/quick_guides_section.dart';
import 'widgets/courses_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).loadUser();
      ref.read(streakProvider.notifier).checkAndUpdateStreak();
      ref.read(settingsProvider.notifier).loadNotificationSetting();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final streak = ref.watch(streakProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wavy Consultation Header
                  StaggeredFadeSlide(
                    index: 0,
                    child: ConsultationHeader(
                      userName: user.name,
                      onAvatarTap: () => context.go('/settings'),
                    ),
                  ),
                  
                  // Talk with Mehrin Card
                  const StaggeredFadeSlide(
                    index: 1,
                    child: TalkWithMehrinCard(),
                  ),
                  const SizedBox(height: 24),

                  // Streak Card
                  StaggeredFadeSlide(
                    index: 1,
                    child: StreakCard(streakCount: streak),
                  ),
                  const SizedBox(height: 4),

                  // Plan Banner
                  StaggeredFadeSlide(
                    index: 2,
                    child: PlanBanner(
                      planType: user.planType,
                      onUpgrade: () => context.push('/settings/paywall'),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Daily Tip
                  StaggeredFadeSlide(
                    index: 3,
                    child: DailyTipCard(tip: DummyData.todaysTip),
                  ),
                  const SizedBox(height: 20),

                  // Quick Guides
                  StaggeredFadeSlide(
                    index: 4,
                    child: QuickGuidesSection(guides: DummyData.guides),
                  ),
                  const SizedBox(height: 24),

                  // Courses
                  StaggeredFadeSlide(
                    index: 5,
                    child: CoursesSection(courses: DummyData.courses),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
