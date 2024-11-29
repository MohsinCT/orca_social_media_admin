import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/controller/web/login_controller.dart';
import 'package:orca_social_media_admin/view/screens/login/login_field.dart';
import 'package:orca_social_media_admin/view/widgets/custom_button.dart';

class LoginWeb extends StatelessWidget {
  LoginWeb({super.key});

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: mediaQuery.screenWidth * 0.4,
            height: mediaQuery.screenHeight * 0.9,
            child: Image.asset('assets/orca_logo_trans.png'),
          ),
          SizedBox(width: mediaQuery.screenWidth * 0.08),
          Flexible(
            child: SizedBox(
              width: mediaQuery.screenWidth * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginFields(formKey: formKey),
                  SizedBox(height: mediaQuery.screenHeight * 0.03),
                  CustomButton(
                    buttonText: const Text('Login'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        loginController.login(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
