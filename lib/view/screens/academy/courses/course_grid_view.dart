import 'dart:convert';
import 'dart:io';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/constants/routes.dart';
import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
import 'package:orca_social_media_admin/controller/web/loading_controller.dart';
import 'package:orca_social_media_admin/view/screens/academy/courses/edit_course_dialog.dart';
import 'package:shimmer/shimmer.dart';

class CourseGrid extends StatelessWidget {
  final LoadingController loadingController = Get.put(LoadingController());

  CourseGrid({super.key, required});

  final CourseController courseController =
      Get.find(); // Use the existing controller

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return Obx(() {
      final topFiveCourses = courseController.filteredCourses.take(5).toList();

      if (topFiveCourses.isEmpty) {
        return const Center(
          child: Text(
            'No Course found',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        );
      }

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: mediaQuery.isLarger
              ? 4
              : mediaQuery.isMedium
                  ? 2
                  : 1,
          crossAxisSpacing: 10.0, // Horizontal space between items
          mainAxisSpacing: 10.0, // Vertical space between items
          childAspectRatio: mediaQuery.isLarger
              ? 0.9
              : mediaQuery.isMedium
                  ? 1.5
                  : 2.8, // A
        ),
        itemCount: topFiveCourses.length,
        itemBuilder: (context, index) {
          final course = topFiveCourses[index];
          return Card(
            elevation: 2,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: mediaQuery.screenWidth * 0.5,
                    height: mediaQuery.screenHeight * 0.17,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: _displayImage(course.imagePath),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.screenWidth * 0.04),
                    child: mediaQuery.isLarger
                        ? SizedBox(
                            width: mediaQuery.screenWidth,
                            height: mediaQuery.screenHeight * 0.08,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) =>
                                                  EditCourseDialog(
                                                      newCourseName:
                                                          course.courseName,
                                                      newCourseImage:
                                                          course.imagePath,
                                                      courseId: course.id));
                                        },
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: const Text(
                                                      'Are you Sure'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          await courseController
                                                              .deleteCourse(
                                                                  course.id,
                                                                  context);
                                                          Get.back();
                                                          Get.back();
                                                          html.window.location
                                                              .reload();
                                                        },
                                                        child:
                                                            const Text('Yes')),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('No'))
                                                  ],
                                                );
                                              });
                                        },
                                        icon: const Icon(Icons.delete))
                                  ],
                                ),
                                Text(course.courseName,
                                    style: TextStyle(
                                      fontSize: mediaQuery.screenWidth * 0.01,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          )
                        : ListTile(
                            title: Text(course.courseName,
                                style: TextStyle(
                                  fontSize: mediaQuery.screenWidth * 0.01,
                                  fontWeight: FontWeight.bold,
                                )),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (builder) =>
                                              EditCourseDialog(
                                                newCourseImage:
                                                    course.imagePath,
                                                newCourseName:
                                                    course.courseName,
                                                courseId: course.id,
                                              ));
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content:
                                                  const Text('Are you Sure'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      await courseController
                                                          .deleteCourse(
                                                              course.id,
                                                              context);
                                                      // ignore: use_build_context_synchronously
                                                      Get.back();
                                                      // ignore: use_build_context_synchronously
                                                      Get.back();
                                                      html.window.location
                                                          .reload();
                                                    },
                                                    child: const Text('Yes')),
                                                TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: const Text('No'))
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                          )),
                ElevatedButton(
                  onPressed: () {
                    final jsonString = jsonEncode(course.toJson());
                    print("Encoded JSON ${Uri.encodeComponent(jsonString)}");
                    Get.toNamed(Routes.courseCategories, parameters: {
                      'data':Uri.encodeComponent(jsonString)
                    });
                  },
                  child: const Text('OPEN'),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  // Method to display image based on platform
  Widget _displayImage(String imagePath) {
    const double aspectRatio = 16 / 9; // Set your desired aspect ratio here

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: imagePath.isEmpty
          ? Image.asset(
              'assets/collage.jpg',
              fit: BoxFit.cover,
            )
          : imagePath.startsWith('http')
              ? CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.red),
                )
              : kIsWeb
                  ? Image.memory(
                      base64Decode(imagePath),
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
    );
  }
}
