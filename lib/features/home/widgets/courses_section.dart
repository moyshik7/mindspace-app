import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/animated_button.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../data/models/course_model.dart';
import '../../../providers/providers.dart';

class CoursesSection extends ConsumerWidget {
  final List<CourseModel> courses;

  const CoursesSection({super.key, required this.courses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Self-Care Courses', style: AppTypography.headingM),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Browse All',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            final isEnrolled = user.enrolledCourses.contains(course.id);
            final progress = user.getCourseProgress(course.id);
            final progressPercent =
                isEnrolled ? progress / course.lessonCount : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: AnimatedButton(
                onTap: () => context.push('/home/course/${course.id}'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        course.gradientColors[0].withValues(alpha: 0.12),
                        course.gradientColors[1].withValues(alpha: 0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.surfaceBorder),
                    boxShadow: AppColors.subtleGlow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(course.emoji,
                              style: const TextStyle(fontSize: 36)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  style: AppTypography.headingM
                                      .copyWith(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'by ${course.instructor}',
                                  style: AppTypography.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Badges
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _badge('${course.lessonCount} Lessons',
                              Icons.menu_book_rounded),
                          _badge(
                              course.difficulty, Icons.signal_cellular_alt_rounded),
                          _badge(course.duration, Icons.timer_rounded),
                        ],
                      ),
                      if (isEnrolled) ...[
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progressPercent,
                                  minHeight: 5,
                                  backgroundColor: AppColors.surfaceBorder,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${(progressPercent * 100).round()}%',
                              style: AppTypography.captionBold.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 40,
                          child: GradientButton(
                            text: 'Continue',
                            height: 40,
                            onTap: () =>
                                context.push('/home/course/${course.id}'),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 40,
                          child: GradientButton(
                            text: 'Start Course',
                            height: 40,
                            onTap: () =>
                                context.push('/home/course/${course.id}'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _badge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceBorder, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textMuted),
          const SizedBox(width: 5),
          Text(text, style: AppTypography.caption.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}
