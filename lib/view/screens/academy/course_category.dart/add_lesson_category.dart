import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
import 'package:orca_social_media_admin/controller/web/loading_controller.dart';

class AddLessonCategory extends StatelessWidget {
  final LoadingController loadingController = Get.put(LoadingController());
  final CourseController courseController = Get.put(CourseController());
  final String courseid;
  final String categoryid;
  AddLessonCategory(
      {super.key, required this.courseid, required this.categoryid});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        'Add lesson',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
          child: Column(children: [
        GestureDetector(
          onTap: () async {
            loadingController.setLoadingForVideo(true);
            await courseController.pickLessonVideo(ImageSource.gallery);
            loadingController.setLoadingForVideo(false);
          },
          child: Obx(() {
            return Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: loadingController.isLoadingForVideo.value
                  ? const Center(child: CircularProgressIndicator())
                  : courseController.videoPath.isNotEmpty
                      ? const Icon(
                          Icons.videocam,
                          size: 50,
                          color: Colors.blue,
                        )
                      : const Icon(
                          Icons.videocam,
                          size: 50,
                          color: Colors.grey,
                        ),
            );
          }),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: courseController.lessonName,
          decoration: const InputDecoration(
            labelText: 'Lesson name....',
            border: OutlineInputBorder(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: () {
                  courseController.resetVideo();
                  courseController.lessonName.clear();

                  Navigator.of(context).pop();
                },
                child: const Text('Clear')),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (courseController.videoPath.isNotEmpty &&
                      courseController.lessonName.text.isNotEmpty) {
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
                    await courseController.addLessonsToCategory(
                        context, courseid, categoryid);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  log('Error lesson $e');
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ])),
    );
  }
}
