// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
import 'package:orca_social_media_admin/controller/web/loading_controller.dart';
import 'package:shimmer/shimmer.dart';

class EditCourseDialog extends StatelessWidget {
  final CourseController courseController = Get.put(CourseController());
  final LoadingController loadingController = Get.put(LoadingController());
  final String courseId;
  final String newCourseName;
  final String newCourseImage;

  EditCourseDialog(
      {super.key,
      required this.newCourseName,
      required this.newCourseImage,
      required this.courseId}) {
    courseController.courseName.text = newCourseName;
    courseController.imagePath.value = newCourseImage;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        'Edit Course',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                loadingController.setLoadingForCourseImage(true);
                await courseController.pickimage(ImageSource.gallery);
                loadingController.setLoadingForCourseImage(false);
              },
              child: Obx(() {
                return Container(
                  width: mediaQuery.screenWidth * 0.3,
                  height: mediaQuery.screenHeight * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: loadingController.isLoadingForCourseImage.value
                      ? const Center(child: CircularProgressIndicator())
                      : courseController.imagePath.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _displayImage(newCourseImage))
                          : const Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.grey,
                            ),
                );
              }),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: courseController.courseName,
              decoration: const InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      courseController.courseName.clear();
                      courseController.resetImage();
                      Get.back();
                    },
                    child: const Text('Clear')),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (courseController.courseName.text.isNotEmpty &&
                          courseController.imagePath.isNotEmpty) {
                        // Show the loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // Prevent closing the dialog by tapping outside
                          builder: (context) => const AlertDialog(
                            title: Text('Editing Course'),
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 20),
                                Expanded(child: Text('Please wait...')),
                              ],
                            ),
                          ),
                        );

                        await courseController.updateCourse(context, courseId);

                        Get.back();

                        Get.back();

                        html.window.location.reload();
                      } else {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Missing Information'),
                            content: const Text(
                                'Please fill in all fields before adding the course.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      Get.back();

                      showDialog(
                        barrierDismissible: false,
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: Text('An error occurred: $e'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _displayImage(String imagePath) {
  const double aspectRatio = 1 / 1; // Set your desired aspect ratio here

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
