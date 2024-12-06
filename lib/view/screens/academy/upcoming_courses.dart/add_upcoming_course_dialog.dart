import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// ignore: avoid_web_libraries_in_flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/controller/web/loading_controller.dart';
import 'package:orca_social_media_admin/controller/Firebase/upcoming_courses_controller.dart';
import 'package:orca_social_media_admin/view/widgets/custom_close_button.dart';

// ignore: use_key_in_widget_constructors
class AddUpComingCourseDialog extends StatelessWidget {
  final UpComingCoursesController upCoursesController =
      Get.put(UpComingCoursesController());
  final LoadingController loadingController = Get.put(LoadingController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: CustomCloseButton(text: 'Add Upcoming Course', onPressed: (){
        upCoursesController.courseName.clear();
                    upCoursesController.courseDetails.clear();
                    upCoursesController.resetImage();
                    Get.back();
      }),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                loadingController.setLoadingForUpcomingCourseImage(
                    true); // Set loading state to true
                await upCoursesController.pickImage(ImageSource.gallery);
                loadingController.setLoadingForUpcomingCourseImage(
                    false); // Set loading state to false after image is picked
              },
              child: Obx(() {
                return Container(
                  width: mediaQuery.screenWidth * 0.3,
                  height: mediaQuery.screenHeight * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: loadingController.isLoadingForUpcomingCourseImage.value
                      ? const Center(child: CircularProgressIndicator())
                      : upCoursesController.imagePath.isNotEmpty
                          ? _displayImage(upCoursesController.imagePath.value)
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
              controller: upCoursesController.courseName,
              decoration: const InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: upCoursesController.courseDetails,
              maxLines: 5, // Adjust this value for more or fewer lines
              decoration: const InputDecoration(
                labelText: 'Course Details',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
          
          ],
        ),
      ),
      actions: [
         ElevatedButton(
                    onPressed: () async {
                      try {
                        if (upCoursesController.courseName.text.isNotEmpty &&
                            upCoursesController.courseDetails.text.isNotEmpty &&
                            upCoursesController.imagePath.isNotEmpty) {
                          showDialog(
                            context: context,
                            barrierDismissible:
                                false, // Prevent closing the dialog by tapping outside
                            builder: (context) => const AlertDialog(
                              title: Text('Adding New upcoming course'),
                              content: Row(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 20),
                                  Expanded(child: Text('Please wait...')),
                                ],
                              ),
                            ),
                          );
                          await upCoursesController.addUpcomingCourses(context);

                          Get.back();

                          Get.back();

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Upcoming Courses are added. Check them in the User section.'),
                              backgroundColor: Colors.green,
                            ),
                          );

                        
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please fill all fields and add an image.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        log('Error und......... upcoming course $e');
                      }
                    },
                    child: const Text('Add'))
      ],
    );
  }
}

Widget _displayImage(String imagePath) {
  if (imagePath.isEmpty) {
    // Show default image when no image is picked
    return Image.asset('assets/cube-1963300_640.jpg', fit: BoxFit.cover);
  } else if (kIsWeb) {
    // Web: Display image from base64
    return Image.memory(base64Decode(imagePath), fit: BoxFit.cover);
  } else {
    // Non-web: Display image from file
    return Image.file(File(imagePath), fit: BoxFit.cover);
  }
}
