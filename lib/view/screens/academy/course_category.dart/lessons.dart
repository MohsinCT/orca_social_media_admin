import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
import 'package:orca_social_media_admin/model/lesson_model.dart';

import 'package:orca_social_media_admin/view/screens/academy/course_category.dart/add_lesson_category.dart';
import 'package:orca_social_media_admin/view/screens/academy/course_category.dart/videoplayer_screen.dart';
import 'package:orca_social_media_admin/view/widgets/custom_add_button.dart';

class Lessons extends StatelessWidget {
  final CourseController courseController = Get.find();

  // Add required courseId and categoryId to fetch lessons
  final String courseId;
  final String categoryId;

  Lessons({
    super.key,
    required this.courseId,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
      ),
      body: Column(
        children: [
          CustomAddButton(
            text: 'Add Category',
            onTap: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => AddLessonCategory(
                categoryid: categoryId,
                courseid: courseId,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<LessonModel>>(
                stream: courseController.fetchLessons(courseId, categoryId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No lessons found.'));
                  }

                  final lessons = snapshot.data!;

                  return ListView.builder(
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      return Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 100,
                              child: _buildVideoThumbnail(lesson.lessonVideo),
                            ),
                            title: Text(
                              lesson.lessonName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              _playVideo(lesson.lessonVideo, context);
                            },
                            trailing: const Icon(Icons.play_arrow),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoThumbnail(String videoPath) {
    // Display a placeholder or a thumbnail
    return Container(
      color: Colors.grey, // Placeholder color
      child:
          const Icon(Icons.videocam, color: Colors.white), // Placeholder icon
    );
  }

  // Method to play the video
  void _playVideo(String videoPath, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => VideoPlayerScreen(
        videoUrl: videoPath,
      ),
    ));
  }
}
