import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class StreakCard extends StatefulWidget {
  final int streakCount;

  const StreakCard({super.key, required this.streakCount});

  @override
  State<StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nextMilestone = _getNextMilestone(widget.streakCount);
    final progress = (widget.streakCount / nextMilestone).clamp(0.0, 1.0);
    final daysToMilestone = nextMilestone - widget.streakCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFff6b35).withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.surface.withValues(alpha: 0.7),
                    AppColors.surfaceElevated.withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Animated Flame Icon
                      Pulse(
                        infinite: true,
                        duration: const Duration(seconds: 2),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.streakGradient,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFff6b35).withValues(alpha: 0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '🔥',
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                FadeInUp(
                                  duration: const Duration(milliseconds: 600),
                                  child: Text(
                                    '${widget.streakCount}',
                                    style: AppTypography.headingXL.copyWith(
                                      fontSize: 42,
                                      height: 1,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    'Days Streak',
                                    style: AppTypography.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getMotivationText(widget.streakCount),
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textPrimary.withValues(alpha: 0.7),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  
                  // Progress Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$daysToMilestone days to $nextMilestone-day milestone',
                            style: AppTypography.label.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFff6b35).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${(progress * 100).round()}%',
                              style: AppTypography.label.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFff6b35),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Stack(
                        children: [
                          // Track
                          Container(
                            height: 12,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceBorder.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          // Progress
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                widthFactor: progress * _animation.value,
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.streakGradient,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFff6b35).withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getMotivationText(int count) {
    if (count <= 1) return 'Starting a beautiful journey! 🌱';
    if (count <= 3) return 'Off to a great start! Keep it up! ✨';
    if (count <= 7) return 'A week of mindfulness! You\'re doing great! 🌟';
    if (count <= 14) return 'Two weeks strong! You\'re on a roll! 🔥';
    if (count <= 30) return 'Consistency is key. Incredible work! 💪';
    return 'You\'re reaching new heights! Keep glowing! 🌈';
  }

  int _getNextMilestone(int current) {
    final milestones = [3, 7, 10, 14, 21, 30, 50, 60, 90, 100, 180, 365];
    for (final m in milestones) {
      if (current < m) return m;
    }
    return ((current ~/ 100) + 1) * 100;
  }
}
