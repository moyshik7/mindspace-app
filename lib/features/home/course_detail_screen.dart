import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/gradient_button.dart';
import '../../data/dummy_data.dart';
import '../../data/models/course_model.dart';
import '../../data/models/user_model.dart';
import '../../providers/providers.dart';

class CourseDetailScreen extends ConsumerWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = DummyData.courses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => DummyData.courses.first,
    );
    final user = ref.watch(userProvider);
    final isEnrolled = user.enrolledCourses.contains(course.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero Header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      course.gradientColors[0].withValues(alpha: 0.3),
                      course.gradientColors[1].withValues(alpha: 0.1),
                      AppColors.background,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Hero(
                        tag: 'course_${course.id}',
                        child: Text(
                          course.emoji,
                          style: const TextStyle(fontSize: 72),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        course.title,
                        style: AppTypography.headingL,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'by ${course.instructor}',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Course info badges
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _infoBadge(Icons.menu_book_rounded,
                      '${course.lessonCount} Lessons'),
                  const SizedBox(width: 12),
                  _infoBadge(
                      Icons.signal_cellular_alt_rounded, course.difficulty),
                  const SizedBox(width: 12),
                  _infoBadge(Icons.timer_rounded, course.duration),
                ],
              ),
            ),
          ),

          // Description
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                course.description,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
            ),
          ),

          // Progress if enrolled
          if (isEnrolled)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Your Progress', style: AppTypography.bodyMedium),
                        Text(
                          '${user.getCourseProgress(courseId)}/${course.lessonCount}',
                          style: AppTypography.captionBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: user.getCourseProgress(courseId) /
                            course.lessonCount,
                        minHeight: 6,
                        backgroundColor: AppColors.surfaceBorder,
                        valueColor: const AlwaysStoppedAnimation(
                            AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

          // Lessons header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Lessons', style: AppTypography.headingM),
            ),
          ),

          // Lesson list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= course.lessons.length) return null;
                final lesson = course.lessons[index];
                final isCompleted =
                    ref.read(userProvider.notifier).isLessonCompleted(
                          courseId,
                          index,
                        );
                final isLocked = user.planType == PlanType.free && index >= 3;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: InkWell(
                    onTap: isLocked
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Upgrade to Pro to unlock all lessons 🔒'),
                              ),
                            );
                          }
                        : () {
                            if (!isEnrolled) {
                              ref
                                  .read(userProvider.notifier)
                                  .enrollCourse(courseId);
                            }
                            context.push(
                              '/home/course/$courseId/lesson/$index',
                            );
                          },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Row(
                        children: [
                          // Lesson number circle
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted
                                  ? AppColors.primary
                                  : Colors.transparent,
                              border: Border.all(
                                color: isCompleted
                                    ? AppColors.primary
                                    : isLocked
                                        ? AppColors.textMuted
                                        : AppColors.surfaceBorder,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(Icons.check_rounded,
                                      size: 18, color: Colors.white)
                                  : isLocked
                                      ? const Icon(Icons.lock_rounded,
                                          size: 14,
                                          color: AppColors.textMuted)
                                      : Text(
                                          '${index + 1}',
                                          style:
                                              AppTypography.captionBold,
                                        ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lesson.title,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isLocked
                                        ? AppColors.textMuted
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lesson.duration,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isLocked
                                ? Icons.lock_outline_rounded
                                : Icons.chevron_right_rounded,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: course.lessons.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),

      // Bottom CTA
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          12 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(
              color: AppColors.surfaceBorder.withValues(alpha: 0.5),
            ),
          ),
        ),
        child: GradientButton(
          text: isEnrolled ? 'Continue Learning' : 'Start Course',
          onTap: () {
            if (!isEnrolled) {
              ref.read(userProvider.notifier).enrollCourse(courseId);
            }
            // Navigate to the first incomplete lesson
            final nextLesson = _findNextLesson(ref, course);
            context.push('/home/course/$courseId/lesson/$nextLesson');
          },
        ),
      ),
    );
  }

  int _findNextLesson(WidgetRef ref, CourseModel course) {
    for (int i = 0; i < course.lessons.length; i++) {
      if (!ref.read(userProvider.notifier).isLessonCompleted(courseId, i)) {
        return i;
      }
    }
    return 0;
  }

  Widget _infoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.surfaceBorder, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Text(text, style: AppTypography.caption),
        ],
      ),
    );
  }
}
