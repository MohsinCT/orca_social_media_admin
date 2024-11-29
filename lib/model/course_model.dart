import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;
  final String courseName;
  final String imagePath;

  CourseModel({
    required this.id,
    required this.courseName,
    required this.imagePath,
  });

  // Factory method to create a CourseModel from Firestore DocumentSnapshot
  factory CourseModel.fromDocument(DocumentSnapshot doc) {
    return CourseModel(
      id: doc['id'] ?? '',
      courseName: doc['courseName'] ?? '',
      imagePath: doc['image'] ?? '',
    );
  }

  // Factory method to create a CourseModel from JSON
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? '',
      courseName: json['courseName'] ?? '',
      imagePath: json['image'] ?? '',
    );
  }

  // Factory method to create a CourseModel from a Map (added)
  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] ?? '',
      courseName: map['courseName'] ?? '',
      imagePath: map['image'] ?? '',
    );
  }

  // Method to convert CourseModel to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseName': courseName,
      'image': imagePath,
    };
  }

  // Method to convert CourseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'image': imagePath,
    };
  }
}
