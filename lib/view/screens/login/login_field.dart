import 'package:flutter/material.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/constants/validator.dart';
import 'package:orca_social_media_admin/view/widgets/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:orca_social_media_admin/controller/web/login_controller.dart';

class LoginFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  LoginFields({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final LoginController loginController = Get.find<LoginController>(); // Get the LoginController instance

    return Form(
      key: formKey,
      child: Column(
        children: [
          NewCustomTextFormField(
            controller: loginController.adminController,
            validator: (value) => ValidationUtils.validate(value, 'AdminName'),
            labelText: 'Admin',
          ),
          SizedBox(
            height: mediaQuery.screenHeight * 0.02,
          ),
          Obx(() { // Use Obx to reactively update the password field
            return NewCustomTextFormField(
              isPassword: true,
              validator: (value) => ValidationUtils.validate(value, 'Password') ,
              obscureText: loginController.obscureText.value, // Use the observable value
              controller: loginController.passwordController,
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  loginController.obscureText.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  loginController.toggleObscureText(); // Toggle visibility on press
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
