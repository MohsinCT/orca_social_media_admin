import 'package:get/get.dart';

class TextFieldController extends GetxController {
  // Observable variable for obscuring text (password field)
  var obscureText = true.obs;

  // Method to toggle password visibility
  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }
}
