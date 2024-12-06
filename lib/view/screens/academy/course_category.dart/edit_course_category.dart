import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
import 'package:orca_social_media_admin/controller/web/loading_controller.dart';
import 'package:orca_social_media_admin/view/widgets/custom_close_button.dart';
import 'package:shimmer/shimmer.dart';

class EditCourseCategory extends StatelessWidget {
  final LoadingController loadingController = Get.put(LoadingController());
  final CourseController courseController = Get.put(CourseController());
  final String categoryId;
  final String courseId;
  final String newCategoryImage;
  final String newCategoryName;
  final String newCategorybaseCourseName;
  final int newLessonCount;

  EditCourseCategory(
      {super.key,
      required this.categoryId,
      required this.newCategoryName,
      required this.newCategorybaseCourseName,
      required this.newLessonCount, 
      required this.newCategoryImage, required this.courseId}){
        courseController.categoryImage.value = newCategoryImage;
        courseController.categoryName.text = newCategoryName;
        courseController.categoryBasedCourseName.text = newCategorybaseCourseName;
        courseController.lessonsCount.text = newLessonCount.toString() ;

      }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: CustomCloseButton(text: 'Edit Category', onPressed: (){
        courseController.resetImage();
              courseController.categoryName;
              courseController.categoryBasedCourseName;
              courseController.lessonsCount.clear();
              Get.back();
      }),
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
                              child: _displayImage(
                                  courseController.categoryImage.value))
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
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            try{
              if(courseController.categoryImage.isNotEmpty &&
                courseController.categoryName.text.isNotEmpty &&
                courseController.categoryBasedCourseName.text.isNotEmpty &&
                courseController.lessonsCount.text.isNotEmpty  
              ){
                showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevent closing the dialog by tapping outside
                    builder: (context) => const AlertDialog(
                      title: Text('Editing Category Course'),
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Expanded(child: Text('Please wait...')),
                        ],
                      ),
                    ),
                  );

                  await courseController.editCategoryCourse(context, courseId, categoryId);
                  Get.back();
                  Get.back();

              } else{
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields and add an image.'),
                      backgroundColor: Colors.red,
                    ),
                  );

              }

            }catch  (e){
              log('Error und........category course');

            }

          },
          child: const Text('Edit'),
        )
      ],
    );
  }
}

Widget _displayImage(String imagePath) {
  const double aspectRatio = 1 / 1;

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
