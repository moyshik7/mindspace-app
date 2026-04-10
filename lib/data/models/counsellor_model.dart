import 'package:flutter/material.dart';

class CounsellorModel {
  final int id;
  final String slug;
  final String name;
  final String title;
  final String image;
  final String experience;
  final String specialization;
  final String availability;
  final String credentials;
  final List<String> expertise;
  final String training;
  final String shortBio;
  final List<String> keywords;

  CounsellorModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.title,
    required this.image,
    required this.experience,
    required this.specialization,
    required this.availability,
    required this.credentials,
    required this.expertise,
    required this.training,
    required this.shortBio,
    required this.keywords,
  });

  factory CounsellorModel.fromJson(Map<String, dynamic> json) {
    return CounsellorModel(
      id: json['id'] as int,
      slug: json['slug'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      image: "https://www.mindspacebd.com${json['image']}",
      experience: json['experience'] as String,
      specialization: json['specialization'] as String,
      availability: json['availability'] as String,
      credentials: json['credentials'] as String,
      expertise: List<String>.from(json['expertise']),
      training: json['training'] as String,
      shortBio: json['shortBio'] as String,
      keywords: List<String>.from(json['keywords']),
    );
  }
}
