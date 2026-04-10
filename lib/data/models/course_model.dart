import 'package:flutter/material.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final int lessonCount;
  final String difficulty;
  final String duration;
  final List<LessonModel> lessons;
  final List<Color> gradientColors;
  final String emoji;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.lessonCount,
    required this.difficulty,
    required this.duration,
    required this.lessons,
    required this.gradientColors,
    required this.emoji,
  });
}

class LessonModel {
  final String title;
  final String duration;
  final String content;

  const LessonModel({
    required this.title,
    required this.duration,
    required this.content,
  });
}
