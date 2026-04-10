enum PlanType { free, pro, ultra }

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final PlanType planType;
  final int streakCount;
  final DateTime? lastOpenDate;
  final List<String> enrolledCourses;
  final Map<String, int> courseProgress; // courseId -> completed lesson count
  final Set<String> completedLessons; // "courseId_lessonIndex"
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.planType = PlanType.free,
    this.streakCount = 1,
    this.lastOpenDate,
    this.enrolledCourses = const [],
    this.courseProgress = const {},
    this.completedLessons = const {},
    required this.createdAt,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    PlanType? planType,
    int? streakCount,
    DateTime? lastOpenDate,
    List<String>? enrolledCourses,
    Map<String, int>? courseProgress,
    Set<String>? completedLessons,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      planType: planType ?? this.planType,
      streakCount: streakCount ?? this.streakCount,
      lastOpenDate: lastOpenDate ?? this.lastOpenDate,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      courseProgress: courseProgress ?? this.courseProgress,
      completedLessons: completedLessons ?? this.completedLessons,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  int getCourseProgress(String courseId) {
    return courseProgress[courseId] ?? 0;
  }

  String get planBadge {
    switch (planType) {
      case PlanType.free:
        return 'Free';
      case PlanType.pro:
        return 'Pro ⭐';
      case PlanType.ultra:
        return 'Ultra 💎';
    }
  }

  static UserModel get demo => UserModel(
        uid: 'demo',
        name: 'Sayuri',
        email: 'sayuri@mindspace.app',
        planType: PlanType.free,
        streakCount: 7,
        lastOpenDate: DateTime.now(),
        enrolledCourses: ['course_1'],
        courseProgress: {'course_1': 3},
        completedLessons: {
          'course_1_0',
          'course_1_1',
          'course_1_2',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
}
