import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/guide_detail_screen.dart';
import '../../features/home/course_detail_screen.dart';
import '../../features/home/lesson_player_screen.dart';
import '../../features/community/community_screen.dart';
import '../../features/community/write_post_screen.dart';
import '../../features/mehrin/mehrin_screen.dart';
import '../../features/resources/resources_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/edit_profile_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/consultation/screens/counsellor_detail_screen.dart';
import '../../features/settings/paywall_screen.dart';
import '../../features/consultation/counsellors_screen.dart';
import '../../features/settings/privacy_policy_screen.dart';
import '../../features/settings/terms_of_service_screen.dart';
import '../../features/settings/feedback_screen.dart';
import '../../data/models/counsellor_model.dart';
import '../../shell/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Custom slide + fade transition
class _SlideTransitionPage extends CustomTransitionPage<void> {
  _SlideTransitionPage({
    required super.child,
    super.key,
  }) : super(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnim = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curvedAnim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(curvedAnim),
                child: child,
              ),
            );
          },
        );
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // Splash
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
      ),
    ),

    // Onboarding
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen(),
      ),
    ),

    // Login
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
      ),
    ),

    // --- FULL SCREEN OVERLAY ROUTES (Root level) ---
    
    GoRoute(
      path: '/profile/:uid',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: ProfileScreen(
          uid: state.pathParameters['uid'],
        ),
      ),
    ),

    GoRoute(
      path: '/home/counsellors',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: const CounsellorsScreen(),
      ),
      routes: [
        GoRoute(
          path: ':id',
          pageBuilder: (context, state) {
            final counsellor = state.extra as CounsellorModel;
            return _SlideTransitionPage(
              key: state.pageKey,
              child: CounsellorDetailScreen(counsellor: counsellor),
            );
          },
        ),
      ],
    ),

    GoRoute(
      path: '/community/write-post',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: const WritePostScreen(),
      ),
    ),

    GoRoute(
      path: '/settings/profile',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: const ProfileScreen(),
      ),
    ),

    GoRoute(
      path: '/settings/edit-profile',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: const EditProfileScreen(),
      ),
    ),

    GoRoute(
      path: '/settings/paywall',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: const PaywallScreen(),
      ),
    ),

    GoRoute(
      path: '/settings/privacy',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: const PrivacyPolicyScreen(),
      ),
    ),

    GoRoute(
      path: '/settings/tos',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: const TermsOfServiceScreen(),
      ),
    ),

    GoRoute(
      path: '/settings/feedback',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: const FeedbackScreen(),
      ),
    ),

    GoRoute(
      path: '/home/guide/:id',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: GuideDetailScreen(
          guideId: state.pathParameters['id']!,
        ),
      ),
    ),
    
    GoRoute(
      path: '/home/course/:id',
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: CourseDetailScreen(
          courseId: state.pathParameters['id']!,
        ),
      ),
      routes: [
        GoRoute(
          path: 'lesson/:lessonIndex',
          pageBuilder: (context, state) => _SlideTransitionPage(
            key: state.pageKey,
            child: LessonPlayerScreen(
              courseId: state.pathParameters['id']!,
              lessonIndex: int.tryParse(
                      state.pathParameters['lessonIndex']!) ??
                  0,
            ),
          ),
        ),
      ],
    ),

    // --- MAIN SHELL (Bottom Nav) ---

    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        // Determine current tab index from location
        final location = state.uri.toString();
        int index = 0;
        if (location.startsWith('/community')) {
          index = 1;
        } else if (location.startsWith('/mehrin')) {
          index = 2;
        } else if (location.startsWith('/resources')) {
          index = 3;
        } else if (location.startsWith('/settings')) {
          index = 4;
        }

        return AppShell(
          currentIndex: index,
          onTabChanged: (i) {
            switch (i) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.go('/community');
                break;
              case 2:
                context.go('/mehrin');
                break;
              case 3:
                context.go('/resources');
                break;
              case 4:
                context.go('/settings');
                break;
            }
          },
          child: child,
        );
      },
      routes: [
        // Home tab root
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => _SlideTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
        ),

        // Community tab root
        GoRoute(
          path: '/community',
          pageBuilder: (context, state) => _SlideTransitionPage(
            key: state.pageKey,
            child: const CommunityScreen(),
          ),
        ),

        // Mehrin AI tab root
        GoRoute(
          path: '/mehrin',
          pageBuilder: (context, state) => _SlideTransitionPage(
            key: state.pageKey,
            child: const MehrinScreen(),
          ),
        ),

        // Resources tab root
        GoRoute(
          path: '/resources',
          pageBuilder: (context, state) => _SlideTransitionPage(
            key: state.pageKey,
            child: const ResourcesScreen(),
          ),
        ),

        // Settings tab root
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => _SlideTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
          ),
        ),
      ],
    ),
  ],
);
