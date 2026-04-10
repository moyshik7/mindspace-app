import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/gradient_button.dart';
import '../../data/dummy_data.dart';
import '../../providers/providers.dart';

class LessonPlayerScreen extends ConsumerStatefulWidget {
  final String courseId;
  final int lessonIndex;

  const LessonPlayerScreen({
    super.key,
    required this.courseId,
    required this.lessonIndex,
  });

  @override
  ConsumerState<LessonPlayerScreen> createState() =>
      _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> {
  late ConfettiController _confettiController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = DummyData.courses.firstWhere(
      (c) => c.id == widget.courseId,
      orElse: () => DummyData.courses.first,
    );

    final lessonIndex = widget.lessonIndex.clamp(0, course.lessons.length - 1);
    final lesson = course.lessons[lessonIndex];
    final isAlreadyComplete = ref
        .read(userProvider.notifier)
        .isLessonCompleted(widget.courseId, lessonIndex);
    final hasNext = lessonIndex < course.lessons.length - 1;
    final hasPrevious = lessonIndex > 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              // Top bar
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              course.title,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Lesson ${lessonIndex + 1} of ${course.lessons.length}',
                              style: AppTypography.captionBold.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: (lessonIndex + 1) / course.lessons.length,
                    minHeight: 3,
                    backgroundColor: AppColors.surfaceBorder,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: AppTypography.headingL,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.timer_rounded,
                              size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(lesson.duration,
                              style: AppTypography.caption),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildContent(lesson.content),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Bottom navigation
              Container(
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
                child: Row(
                  children: [
                    if (hasPrevious)
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => LessonPlayerScreen(
                                courseId: widget.courseId,
                                lessonIndex: lessonIndex - 1,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_back_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                                color: AppColors.surfaceBorder),
                          ),
                        ),
                      ),
                    if (hasPrevious) const SizedBox(width: 12),
                    Expanded(
                      child: GradientButton(
                        text: isAlreadyComplete || _isCompleted
                            ? (hasNext ? 'Next Lesson' : 'Finish Course')
                            : 'Mark Complete & Next',
                        onTap: () {
                          if (!isAlreadyComplete && !_isCompleted) {
                            ref.read(userProvider.notifier).completeLesson(
                                  widget.courseId,
                                  lessonIndex,
                                );
                            _confettiController.play();
                            setState(() => _isCompleted = true);

                            if (!hasNext) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      '🎉 Congratulations! Course completed!'),
                                ),
                              );
                              final nav = Navigator.of(context);
                              Future.delayed(
                                const Duration(seconds: 2),
                                () {
                                  if (mounted) nav.pop();
                                },
                              );
                              return;
                            }
                          }

                          if (hasNext) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => LessonPlayerScreen(
                                  courseId: widget.courseId,
                                  lessonIndex: lessonIndex + 1,
                                ),
                              ),
                            );
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.primaryLight,
                AppColors.primaryMid,
                AppColors.success,
                Color(0xFFffd700),
              ],
              numberOfParticles: 30,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String content) {
    final lines = content.trim().split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        widgets.add(const SizedBox(height: 12));
      } else if (trimmed.startsWith('• ') || trimmed.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ',
                  style:
                      AppTypography.body.copyWith(color: AppColors.primary)),
              Expanded(
                child: Text(
                  trimmed.substring(2),
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
        ));
      } else {
        // Check for bold-like headers
        final isBoldHeader =
            trimmed.endsWith(':') && trimmed.length < 60;
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            trimmed,
            style: isBoldHeader
                ? AppTypography.bodyMedium.copyWith(
                    color: AppColors.primaryLight,
                    height: 1.7,
                  )
                : AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.7,
                  ),
          ),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
