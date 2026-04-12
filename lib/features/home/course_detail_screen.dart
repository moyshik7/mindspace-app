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

class CourseDetailScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = DummyData.courses.firstWhere(
      (c) => c.id == widget.courseId,
      orElse: () => DummyData.courses.first,
    );
    final user = ref.watch(userProvider);
    final isEnrolled = user.enrolledCourses.contains(course.id);
    final progress = user.getCourseProgress(widget.courseId);
    final progressPercent = (progress / course.lessonCount).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1113),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: AppTypography.headingL.copyWith(
                            color: Colors.white,
                            fontSize: 26,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${course.lessonCount} Lessons • ${course.instructor}',
                          style: AppTypography.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // TabBar
            TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFFD8335B),
              indicatorWeight: 3,
              labelColor: const Color(0xFFD8335B),
              unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
              labelStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              dividerColor: Colors.white.withValues(alpha: 0.05),
              tabs: const [
                Tab(text: 'Lessons'),
                Tab(text: 'Description'),
                Tab(text: 'Achievement'),
              ],
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Lessons Tab
                  _buildLessonsTab(context, ref, course, user, isEnrolled),
                  // Description Tab
                  _buildDescriptionTab(course),
                  // Achievement Tab
                  _buildAchievementTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: !isEnrolled
          ? Container(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1113),
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                ),
              ),
              child: GradientButton(
                text: 'Enroll Now',
                onTap: () {
                  ref.read(userProvider.notifier).enrollCourse(widget.courseId);
                },
              ),
            )
          : null,
    );
  }

  Widget _buildLessonsTab(
    BuildContext context,
    WidgetRef ref,
    CourseModel course,
    UserModel user,
    bool isEnrolled,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      itemCount: course.lessons.length,
      itemBuilder: (context, index) {
        final lesson = course.lessons[index];
        final isCompleted = ref.read(userProvider.notifier).isLessonCompleted(
              widget.courseId,
              index,
            );
        final isLocked = user.planType == PlanType.free && index >= 3;
        final lessonNumber = (index + 1).toString().padLeft(2, '0');

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: isLocked
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Upgrade to Pro to unlock all lessons 🔒'),
                      ),
                    );
                  }
                : () {
                    if (!isEnrolled) {
                      ref.read(userProvider.notifier).enrollCourse(widget.courseId);
                    }
                    context.push('/home/course/${widget.courseId}/lesson/$index');
                  },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D21),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        lessonNumber,
                        style: AppTypography.headingM.copyWith(
                          color: const Color(0xFFD8335B),
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson.title,
                              style: AppTypography.bodyMedium.copyWith(
                                color: isLocked ? Colors.white.withValues(alpha: 0.4) : Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isLocked ? 'Locked' : lesson.duration,
                              style: AppTypography.caption.copyWith(
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLocked)
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD8335B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      else
                        const Icon(Icons.lock_rounded, color: Colors.white24, size: 20),
                    ],
                  ),
                  if (isEnrolled && !isLocked && isCompleted) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 1.0,
                              minHeight: 4,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF67E88F)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '100%',
                          style: TextStyle(color: Color(0xFF67E88F), fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionTab(CourseModel course) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What will I learn:',
            style: AppTypography.headingM.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            course.description,
            style: AppTypography.body.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.6,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          // Additional sections to match mockup
          _learnItem('Foundations', 'Master the core concepts and fundamental principles of ${course.title}.'),
          _learnItem('Practical Application', 'Learn how to apply your knowledge in real-world scenarios and projects.'),
          _learnItem('Expert Techniques', 'Discover advanced tips and tricks used by industry professionals.'),
        ],
      ),
    );
  }

  Widget _learnItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: AppTypography.body.copyWith(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events_rounded,
              size: 64,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Achievements',
            style: AppTypography.headingM.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon',
            style: AppTypography.body.copyWith(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
