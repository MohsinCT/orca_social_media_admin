import 'package:cloud_firestore/cloud_firestore.dart';

class CourseCategoryModel {
  final String id;
  final String categoryImage;
  final String categoryName;
  final int lessonCount;
  final String categoryCourseName;

  CourseCategoryModel(
      {required this.id,
      required this.categoryImage,
      required this.categoryName,
      required this.lessonCount,
      required this.categoryCourseName});

  factory CourseCategoryModel.fromDocument(DocumentSnapshot doc) {
    return CourseCategoryModel(
        id: doc['id'] ?? '',
        categoryImage: doc['categoryImage'] ?? '',
        categoryName: doc['categoryName'] ?? '',
        lessonCount: doc['lessonCount'] ?? 0,
        categoryCourseName: doc['categoryCourseName'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryImage': categoryImage,
      'categoryName': categoryName,
      'lessonCount': lessonCount,
      'categoryCourseName': categoryCourseName
    };
  }

  factory CourseCategoryModel.fromJson(Map<String, dynamic> json) {
    return CourseCategoryModel(
        id: json['id'] ?? '',
        categoryImage: json['categoryImage'] ?? '',
        categoryName: json['categoryName'] ?? '',
        lessonCount: json['lessonCount'] ?? 0,
        categoryCourseName: json['categoryCourseName'] ?? '');
  }
}
