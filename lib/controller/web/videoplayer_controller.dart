import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerControllerX extends GetxController {
  final String videoUrl;
  late VideoPlayerController videoPlayerController;
  RxBool isPlaying = true.obs;

  VideoPlayerControllerX(this.videoUrl);

  @override
  void onInit() {
    super.onInit();
    // ignore: deprecated_member_use
    videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        videoPlayerController.setLooping(true);
        videoPlayerController.play();
        update(); // Update the UI when the video is initialized
      });
  }

  void togglePlayPause() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
      isPlaying.value = false;
    } else {
      videoPlayerController.play();
      isPlaying.value = true;
    }
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}
