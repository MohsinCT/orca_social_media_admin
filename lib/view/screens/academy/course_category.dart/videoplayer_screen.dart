import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
import 'package:orca_social_media_admin/controller/web/videoplayer_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controllers
    final videoController = Get.put(VideoPlayerControllerX(videoUrl));
    final courseController = Get.put(CourseController());

    

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          // Display the course name from CourseController in the AppBar title
          return Text(courseController.lessonNameObs.value);
        }),
      ),
      body: Center(
        child: GetBuilder<VideoPlayerControllerX>(
          builder: (controller) {
            return controller.videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: controller.videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(controller.videoPlayerController),
                  )
                : const CircularProgressIndicator(); // Display loading indicator while video initializes
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => videoController.togglePlayPause(),
        child: Obx(() => Icon(
          videoController.isPlaying.value ? Icons.pause : Icons.play_arrow,
        )),
      ),
    );
  }
}
