import 'package:get/get.dart';

class BottomNavController extends GetxController{
  var currentIndex = ''.obs;

  void setCurrentIndex(String page){
    currentIndex.value = page ;
  }
}