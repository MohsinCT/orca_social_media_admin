import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
import 'package:orca_social_media_admin/controller/Firebase/fetch_upcoming_courses.dart';
import 'package:orca_social_media_admin/controller/web/loading_controller.dart';
import 'package:orca_social_media_admin/controller/Firebase/upcoming_courses_controller.dart';
import 'package:orca_social_media_admin/view/screens/academy/courses/add_course_dialog.dart';
import 'package:orca_social_media_admin/view/screens/academy/courses/add_upcoming_course_dialog.dart';
import 'package:orca_social_media_admin/view/screens/academy/courses/carousel_upcoming_course.dart';
import 'package:orca_social_media_admin/view/screens/academy/courses/course_grid_view.dart';
import 'package:orca_social_media_admin/view/widgets/custom_add_button.dart';

class AcademyContents extends StatelessWidget {
  AcademyContents({super.key});

  final CourseController courseController = Get.put(CourseController());
  final ImagePicker imagePicker = ImagePicker();
  final UpComingCoursesController upCoursesController =
      Get.put(UpComingCoursesController());
  final LoadingController loadingController = Get.put(LoadingController());
  final FetchUpcomingCourses fetchUpcomingCourses =
      Get.put(FetchUpcomingCourses());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return SingleChildScrollView(
      child: SizedBox(
        width: mediaQuery.screenWidth,
        height: mediaQuery.screenHeight,
        child: ListView(children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.screenHeight * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomAddButton(
                      text: 'Add new course',
                      onTap: () => showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => AddCourseDialog(),
                      ),
                    ),
                    SizedBox(width: mediaQuery.screenWidth * 0.01),
                    CustomAddButton(
                      text: 'Add upcoming courses',
                      onTap: () => showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => AddUpComingCourseDialog(),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: mediaQuery.screenHeight * 0.03),
                    child: const Text(
                      'Upcoming courses',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ],
              ),
              CarouselUpcomingCourse(),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: mediaQuery.screenHeight * 0.03),
                    child: const Text(
                      'New courses',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const Spacer(), // Add spacer to push the search field to the right
                  Container(
                    width: mediaQuery.screenWidth * 0.3, // Adjust width as needed
                    padding: EdgeInsets.symmetric(
                        vertical: mediaQuery.screenHeight * 0.02),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search courses...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                      ),
                      onChanged: (value) {
                        courseController.searchCourses(value);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                // Use a fixed height or a wrapping widget for CourseGrid
                height: mediaQuery.screenHeight * 0.3,
                child: CourseGrid(),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
