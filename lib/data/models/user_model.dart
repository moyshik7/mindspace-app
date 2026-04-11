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
  final String bio;
  final String description;
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
    this.bio = '',
    this.description = '',
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
    String? bio,
    String? description,
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
      bio: bio ?? this.bio,
      description: description ?? this.description,
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
        return 'Pro';
      case PlanType.ultra:
        return 'Ultra';
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String? ?? 'User',
      email: json['email'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      planType: PlanType.values.firstWhere(
        (e) => e.name == (json['planType'] as String?),
        orElse: () => PlanType.free,
      ),
      streakCount: json['streakCount'] as int? ?? 1,
      lastOpenDate: json['lastOpenDate'] != null
          ? DateTime.tryParse(json['lastOpenDate'].toString())
          : null,
      enrolledCourses: (json['enrolledCourses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      courseProgress: (json['courseProgress'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          {},
      completedLessons: (json['completedLessons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          {},
      bio: json['bio'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'planType': planType.name,
      'streakCount': streakCount,
      'lastOpenDate': lastOpenDate?.toIso8601String(),
      'enrolledCourses': enrolledCourses,
      'courseProgress': courseProgress,
      'completedLessons': completedLessons.toList(),
      'bio': bio,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
