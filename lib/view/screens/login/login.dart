import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/controller/web/login_controller.dart';
import 'package:orca_social_media_admin/view/mobile/login_mobile.dart';
import 'package:orca_social_media_admin/view/web/login_web.dart';

class LogIn extends StatelessWidget {
  LogIn({super.key});

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: mediaQuery.screenHeight * 0.05),
        child: Center(child: mediaQuery.isMobile ? LoginMobile() : LoginWeb()),
      ),
    );
  }
}
