import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/upcoming_course_model.dart';

class UpcomingCourseDetails extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  UpcomingCourseDetails({super.key});

  late final UpcomingCourseModel upComingCourse;

  @override
  Widget build(BuildContext context) {
    final data = Get.parameters['data'];
    if (data != null) {
      final decodedData = Uri.decodeComponent(data);
      try {
        upComingCourse = UpcomingCourseModel.fromJson(jsonDecode(decodedData));
      } catch (e) {
        // print("Error parsing JSON: $e");
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Invalid course data.')),
        );
      }
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No course data provided.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(upComingCourse.upcomingCourseName),
      ),
      body: Center(
        child: Text(upComingCourse.upComingCourseDetails),
      ),
    );
  }
}
