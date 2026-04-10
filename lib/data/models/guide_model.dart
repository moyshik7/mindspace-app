import 'package:flutter/material.dart';

class GuideModel {
  final String id;
  final String title;
  final String emoji;
  final String readTime;
  final String content;
  final List<Color> gradientColors;

  const GuideModel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.readTime,
    required this.content,
    required this.gradientColors,
  });
}
