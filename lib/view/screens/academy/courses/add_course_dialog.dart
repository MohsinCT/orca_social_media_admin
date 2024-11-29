import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
import 'package:orca_social_media_admin/controller/web/loading_controller.dart';

// ignore: use_key_in_widget_constructors
class AddCourseDialog extends StatelessWidget {
  final CourseController courseController = Get.put(CourseController());
  final LoadingController loadingController = Get.put(LoadingController());
  final TextEditingController courseNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        'Add New Course',
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
            const SizedBox(height: 20),

            // First image container for course image
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
                              child: Image.memory(
                                base64Decode(courseController.imagePath.value),
                                fit: BoxFit
                                    .cover, // This scales the image to cover the container within the aspect ratio
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

            // Text field for adding course name
            TextFormField(
              controller: courseController.courseName,
              decoration: const InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    courseNameController.clear();
                    courseController.resetImage();

                    courseController.resetVideo();
                    Get.back();
                  },
                  child: const Text('Clear'),
                ),
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
                            title: Text('Adding new course'),
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 20),
                                Expanded(child: Text('Please wait...')),
                              ],
                            ),
                          ),
                        );

                        // Attempt to add the new course
                        await courseController.addNewCourse(context);

                        // Close the loading dialog after adding the course
                        Get.back();

                        // Close the add course screen
                        Get.back();

                        html.window.location.reload();
                      } else {
                        // Show a dialog if any required field is missing
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
                      // Close the loading dialog if it’s still open
                      Get.back();

                      // Display the error in a dialog
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: Text('An error occurred: $e'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Add'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
