import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  final String id;
  final String lessonVideo;
  final String lessonName;

  // Constructor to initialize the properties
  LessonModel({
    required this.id,
    required this.lessonVideo,
    required this.lessonName,
  });

  // Factory method to create a LessonModel from Firestore DocumentSnapshot
  factory LessonModel.fromDocument(DocumentSnapshot doc) {
    return LessonModel(
      id: doc['id'] ?? '', // Assuming the document has an 'id' field
      lessonVideo: doc['lessonVideo'] ?? '', // Assuming the document has a 'lessonVideo' field
      lessonName: doc['lessonName'] ?? '', // Assuming the document has a 'lessonName' field
    );
  }

  // Factory method to create a LessonModel from JSON
  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] ?? '',
      lessonVideo: json['lessonVideo'] ?? '',
      lessonName: json['lessonName'] ?? '',
    );
  }

  // Factory method to create a LessonModel from a Map (added)
  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map['id'] ?? '',
      lessonVideo: map['lessonVideo'] ?? '',
      lessonName: map['lessonName'] ?? '',
    );
  }

  // Method to convert LessonModel to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lessonVideo': lessonVideo,
      'lessonName': lessonName,
    };
  }

  // Method to convert LessonModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonVideo': lessonVideo,
      'lessonName': lessonName,
    };
  }
}
