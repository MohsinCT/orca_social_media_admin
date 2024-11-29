
import 'package:get/get.dart';

class AdminPanelController extends GetxController {
  var selectedPage = ''.obs;

  void changePage(String page) {
    selectedPage.value = page;
  }
}
