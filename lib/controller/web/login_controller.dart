import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final TextEditingController adminController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var obscureText = true.obs;
  var isLoggedIn = false.obs;

  String adminName = 'admin';
  String password = '123';

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  // Login method
  void login(BuildContext context) {
    if (adminController.text == adminName &&
        passwordController.text == password) {
      log('Login successful');
      Get.offAllNamed('/admin-panel');
    } else {
      Get.snackbar(
        'Login Failed',
        'Incorrect username or password',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    adminController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
