import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orca_social_media_admin/constants/routes.dart';
import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
import 'package:orca_social_media_admin/controller/Firebase/upcoming_courses_controller.dart';
import 'package:orca_social_media_admin/controller/web/admin_panel_controller.dart';
import 'package:orca_social_media_admin/controller/web/loading_controller.dart';
import 'package:orca_social_media_admin/controller/web/login_controller.dart';
import 'package:orca_social_media_admin/controller/web/textfiled_controller.dart';
import 'package:orca_social_media_admin/firebase_options.dart';

import 'package:orca_social_media_admin/view/screens/academy/course_category.dart/course_categories.dart';
import 'package:orca_social_media_admin/view/screens/academy/courses/carousel_details.dart';
import 'package:orca_social_media_admin/view/screens/admin_panel/admin_panel.dart';
import 'package:orca_social_media_admin/view/screens/login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.lazyPut(() => TextFieldController());
  Get.put(LoginController());
  Get.put(CourseController());
  Get.put(LoadingController());

  runApp(MyWeb());
}

class MyWeb extends StatelessWidget {
  final AdminPanelController adminPanelController =
      Get.put(AdminPanelController());
      final upCouses = UpComingCoursesController();

   

   MyWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      getPages: [
        GetPage(name: Routes.login, page: () => LogIn()  ),
        GetPage(name: Routes.adminPanel, page: () => AdminPanel(), ),
        GetPage(name: Routes.courseCategories, page:()=> CourseCategories(), ),
        GetPage(name: Routes.upcomingCourseDetails, page: () =>  UpcomingCourseDetails(), )
      ],
      home: LogIn(),
    );
  }
}
