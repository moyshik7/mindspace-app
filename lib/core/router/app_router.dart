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
import '../../features/settings/settings_screen.dart';
import '../../features/settings/edit_profile_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/consultation/screens/counsellor_detail_screen.dart';
import '../../features/settings/paywall_screen.dart';
import '../../features/consultation/counsellors_screen.dart';
import '../../features/settings/privacy_policy_screen.dart';
import '../../features/settings/terms_of_service_screen.dart';
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

    // Profile (Other users)
    GoRoute(
      path: '/profile/:uid',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _SlideTransitionPage(
        key: state.pageKey,
        child: ProfileScreen(
          uid: state.pathParameters['uid'],
        ),
      ),
    ),

    // Main app with shell (bottom nav)
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
        } else if (location.startsWith('/settings')) {
          index = 3;
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
                context.go('/settings');
                break;
            }
          },
          child: child,
        );
      },
      routes: [
        // Home tab
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => _SlideTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
          routes: [
            GoRoute(
              path: 'counsellors',
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) => _SlideTransitionPage(
                key: state.pageKey,
                child: const CounsellorsScreen(),
              ),
              routes: [
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootNavigatorKey,
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
              path: 'guide/:id',
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) => _SlideTransitionPage(
                key: state.pageKey,
                child: GuideDetailScreen(
                  guideId: state.pathParameters['id']!,
                ),
              ),
            ),
            GoRoute(
              path: 'course/:id',
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) => _SlideTransitionPage(
                key: state.pageKey,
                child: CourseDetailScreen(
                  courseId: state.pathParameters['id']!,
                ),
              ),
              routes: [
                GoRoute(
                  path: 'lesson/:lessonIndex',
                  parentNavigatorKey: _rootNavigatorKey,
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
          ],
        ),

        // Community tab
        GoRoute(
          path: '/community',
          pageBuilder: (context, state) => _SlideTransitionPage(
            key: state.pageKey,
            child: const CommunityScreen(),
          ),
          routes: [
            GoRoute(
              path: 'write-post',
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) => _SlideTransitionPage(
                key: state.pageKey,
                child: const WritePostScreen(),
              ),
            ),
          ],
        ),

        // Mehrin AI tab
        GoRoute(
          path: '/mehrin',
          pageBuilder: (context, state) => _SlideTransitionPage(
            key: state.pageKey,
            child: const MehrinScreen(),
          ),
        ),

        // Settings tab
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => _SlideTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
          ),
          routes: [
            GoRoute(
              path: 'profile',
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) => _SlideTransitionPage(
                key: state.pageKey,
                child: const ProfileScreen(),
              ),
            ),
            GoRoute(
              path: 'edit-profile',
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) => _SlideTransitionPage(
                key: state.pageKey,
                child: const EditProfileScreen(),
              ),
            ),
            GoRoute(
              path: 'paywall',
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) => _SlideTransitionPage(
                key: state.pageKey,
                child: const PaywallScreen(),
              ),
            ),
            GoRoute(
              path: 'privacy',
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) => _SlideTransitionPage(
                key: state.pageKey,
                child: const PrivacyPolicyScreen(),
              ),
            ),
            GoRoute(
              path: 'tos',
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) => _SlideTransitionPage(
                key: state.pageKey,
                child: const TermsOfServiceScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
