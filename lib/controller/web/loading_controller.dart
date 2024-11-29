import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoadingController extends GetxController {
  var isLoadingForCourseImage = false.obs;
  var isLoadingForCategoryImage = false.obs;
  var isLoadingForVideo = false.obs;
  var isLoadingForUpcomingCourseImage = false.obs;

  

  void setLoadingForCourseImage(bool value) {
    isLoadingForCourseImage.value = value;
  }

  void setLoadingForCategory(bool value) {
    isLoadingForCategoryImage.value = value;
  }

  void setLoadingForVideo(bool value) {
    isLoadingForVideo.value = value;
  }

  void setLoadingForUpcomingCourseImage(bool value){
    isLoadingForUpcomingCourseImage.value = value;
  }
}
