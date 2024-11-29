import 'package:cloud_firestore/cloud_firestore.dart';

class UpcomingCourseModel {
  final String id;
  final String upComingCourseImage;
  final String upcomingCourseName;
  final String upComingCourseDetails;

  UpcomingCourseModel({
    required this.id,
    required this.upComingCourseImage,
    required this.upcomingCourseName,
    required this.upComingCourseDetails,
  });

  // Factory constructor to create an instance from Firestore document
  factory UpcomingCourseModel.fromDocument(DocumentSnapshot doc) {
    return UpcomingCourseModel(
      id: doc['id'] ?? '',
      upComingCourseImage: doc['UpcomingCourseImage'] ?? '',
      upcomingCourseName: doc['UpcomingCourseName'] ?? '',
      upComingCourseDetails: doc['UpComingCourseDetails'] ?? '',
    );
  }

  // Factory constructor to create an instance from JSON
  factory UpcomingCourseModel.fromJson(Map<String, dynamic> json) {
    return UpcomingCourseModel(
      id: json['id'] ?? '',
      upComingCourseImage: json['UpcomingCourseImage'] ?? '',
      upcomingCourseName: json['UpcomingCourseName'] ?? '',
      upComingCourseDetails: json['UpComingCourseDetails'] ?? '',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'UpcomingCourseImage': upComingCourseImage,
      'UpcomingCourseName': upcomingCourseName,
      'UpComingCourseDetails': upComingCourseDetails,
    };
  }

  // Method to convert an instance to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'UpcomingCourseImage': upComingCourseImage,
      'UpcomingCourseName': upcomingCourseName,
      'UpComingCourseDetails': upComingCourseDetails,
    };
  }
}
