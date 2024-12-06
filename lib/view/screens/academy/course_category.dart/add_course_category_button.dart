import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
import 'package:orca_social_media_admin/controller/web/loading_controller.dart';
import 'package:orca_social_media_admin/view/widgets/custom_close_button.dart';


// ignore: use_key_in_widget_constructors
class AddCourseCategoryDialog extends StatelessWidget {
  final LoadingController loadingController = Get.put(LoadingController());
  final CourseController courseController = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: CustomCloseButton(text: 'Add Category', onPressed: (){
        
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
              height: 15,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                     Get.back();
                    },
                    child: const Text('Clear')),
                ElevatedButton(
                  onPressed: ()  {
                  
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





