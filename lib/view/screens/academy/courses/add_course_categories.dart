import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
import 'package:orca_social_media_admin/controller/web/loading_controller.dart';

class AddCourseCategories extends StatelessWidget {
  final CourseController courseController = Get.put(CourseController());
  final LoadingController loadingController = Get.put(LoadingController());
  final String courseid;
  AddCourseCategories({super.key, required this.courseid});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        'Add Category',
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
                loadingController.setLoadingForCategory(true);
                await courseController
                    .pickimageForCategory(ImageSource.gallery);
                loadingController.setLoadingForCategory(false);
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
                  child: loadingController.isLoadingForCategoryImage.value
                      ? const Center(child: CircularProgressIndicator())
                      : courseController.categoryImage.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                base64Decode(
                                    courseController.categoryImage.value),
                                fit: BoxFit.cover,
                              ),
                            )
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
              controller: courseController.categoryBasedCourseName,
              decoration: const InputDecoration(
                labelText: 'Category based Course Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Row with Category and Lessons fields
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: courseController.categoryName,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: courseController.lessonsCount,
                    decoration: const InputDecoration(
                      labelText: 'Lessons',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      courseController.resetImage();
                      courseController.categoryName.clear();
                      courseController.categoryBasedCourseName.clear();
                      courseController.lessonsCount.clear();
                      Get.back();
                    },
                    child: const Text('Clear')),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        if (courseController.categoryImage.isNotEmpty &&
                            courseController.categoryName.text.isNotEmpty &&
                            courseController.lessonsCount.text.isNotEmpty &&
                            courseController
                                .categoryBasedCourseName.text.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                    title: Text('Adding new Category'),
                                    content: Row(
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(width: 20),
                                        Expanded(child: Text('Please wait...')),
                                      ],
                                    ));
                              });
                          await courseController.addCategoryCourse(
                              context, courseid);
                          // ignore: use_build_context_synchronously
                          Get.back();

                          // Close the add course screen
                          // ignore: use_build_context_synchronously
                          Get.back();
                        }
                      } catch (e) {
                        log('Error category course $e');
                      }
                    },
                    child: const Text('Add'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
