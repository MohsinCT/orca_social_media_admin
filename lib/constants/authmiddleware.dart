import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orca_social_media_admin/controller/web/login_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final isAuthenticated = Get.find<LoginController>().isLoggedIn.value;
    if (!isAuthenticated) {
      // Redirect to login and replace the route stack to prevent unauthorized navigation
      return const  RouteSettings(name: '/login');
    }
    return null; // Continue to the requested route if authenticated
  }
}
