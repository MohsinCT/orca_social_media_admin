// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/constants/routes.dart';
import 'package:orca_social_media_admin/controller/Firebase/upcoming_courses_controller.dart';
import 'package:orca_social_media_admin/controller/web/loading_controller.dart';

import 'package:shimmer/shimmer.dart';

class CarouselUpcomingCourse extends StatelessWidget {
  final UpComingCoursesController upCoursesController =
      Get.put(UpComingCoursesController());
  final LoadingController loadingController = Get.put(LoadingController());

  CarouselUpcomingCourse({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return Obx(() {
      final upCominCourse = upCoursesController.upComingCourseList.toList();

      if (upCominCourse.isEmpty) {
        return Container(
          width: mediaQuery.screenWidth,
          height: mediaQuery.screenHeight * 0.4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
          child: const Center(
            child: Text('No upcoming courses'),
          ),
        );
      
      }
      return CarouselSlider.builder(
        itemCount: upCominCourse.length,
        options: CarouselOptions(
          height: mediaQuery.screenHeight * 0.4,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          enlargeCenterPage: true,
          viewportFraction: 1.0,
        ),
        itemBuilder: (context, index, realIndex) {
          final upCourses = upCominCourse[index];
          return GestureDetector(
            onTap: () {
              final jsonString = jsonEncode(upCourses.toJson());
              print("Encoded JSON: ${Uri.encodeComponent(jsonString)}");
              Get.toNamed(
                Routes.upcomingCourseDetails,
                parameters: {
                  'data': Uri.encodeComponent(jsonString),
                },
              );
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    width: mediaQuery.screenWidth,
                    height: mediaQuery.screenHeight * 0.6,
                    child: _displayImage(upCourses.upComingCourseImage),
                  ),
                ),
              
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              upCourses.upcomingCourseName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Are you sure'),
                                      content: Row(
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('No')),
                                          ElevatedButton(
                                              onPressed: () async {
                                                await upCoursesController
                                                    .deleteUpcomingCourse(
                                                        upCourses.id, context);

                                                Get.back();
                                                Get.back();
                                                html.window.location.reload();
                                              },
                                              child: const Text('Yes'))
                                        ],
                                      ),
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _displayImage(String imagePath) {
    const double aspectRatio = 1 / 1; // Set your desired aspect ratio here

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: imagePath.isEmpty
          ? Image.asset(
              'assets/collage.jpg',
              fit: BoxFit.cover,
            )
          : imagePath.startsWith('http')
              ? CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.red),
                )
              : kIsWeb
                  ? Image.memory(
                      base64Decode(imagePath),
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
    );
  }

  // void _showEditDialog(BuildContext context, Map<String, dynamic> course) {
  //   upCoursesController.courseName.text = course['courseName'];
  //   upCoursesController.courseDetails.text = course['courseDetails'];
  //   upCoursesController.updateImagePath(course['image'] ?? '');

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         contentPadding: const EdgeInsets.all(16),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         title: const Text(
  //           'Edit Upcoming Course',
  //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //         ),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               GestureDetector(
  //                 onTap: () async {
  //                   loadingController.setLoadingForUpcomingCourseImage(true);
  //                   await upCoursesController.pickImage(ImageSource.gallery);
  //                   loadingController.setLoadingForUpcomingCourseImage(false);
  //                 },
  //                 child: Obx(() {
  //                   return Container(
  //                     width: MediaQuery.of(context).size.width * 0.5,
  //                     height: MediaQuery.of(context).size.height * 0.3,
  //                     decoration: BoxDecoration(
  //                       color: Colors.grey[200],
  //                       borderRadius: BorderRadius.circular(12),
  //                       border: Border.all(color: Colors.grey),
  //                     ),
  //                     child: loadingController
  //                             .isLoadingForUpcomingCourseImage.value
  //                         ? const Center(child: CircularProgressIndicator())
  //                         : upCoursesController.imagePath.isNotEmpty
  //                             ? _displayImage(
  //                                 upCoursesController.imagePath.value)
  //                             : _displayImage(course['image'] ?? ''),
  //                   );
  //                 }),
  //               ),
  //               const SizedBox(height: 20),
  //               TextFormField(
  //                 controller: upCoursesController.courseName,
  //                 decoration: const InputDecoration(
  //                   labelText: 'Course Name',
  //                   border: OutlineInputBorder(),
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               TextFormField(
  //                 controller: upCoursesController.courseDetails,
  //                 maxLines: 5,
  //                 decoration: const InputDecoration(
  //                   labelText: 'Course Details',
  //                   border: OutlineInputBorder(),
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               Row(
  //                 children: [
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       upCoursesController.courseName.clear();
  //                       upCoursesController.courseDetails.clear();
  //                       upCoursesController.resetImage();
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: const Text('Clear'),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ElevatedButton(
  //                     onPressed: () async {
  //                       if (upCoursesController.courseName.text.isNotEmpty &&
  //                           upCoursesController.courseDetails.text.isNotEmpty) {
  //                         await upCoursesController.editUpcomingCourse(
  //                             course['id'], context);

  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           const SnackBar(
  //                             content:
  //                                 Text('Upcoming Course updated successfully.'),
  //                             backgroundColor: Colors.green,
  //                           ),
  //                         );

  //                         Navigator.of(context).pop();
  //                       } else {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           const SnackBar(
  //                             content: Text('Please fill all fields.'),
  //                             backgroundColor: Colors.red,
  //                           ),
  //                         );
  //                       }
  //                     },
  //                     child: const Text('Update'),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
