import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/constants/routes.dart';
import 'package:orca_social_media_admin/controller/Firebase/upcoming_courses_controller.dart';
import 'package:orca_social_media_admin/model/upcoming_course_model.dart';
import 'package:orca_social_media_admin/view/screens/academy/upcoming_courses.dart/edit_upcoming_course.dart';
import 'package:shimmer/shimmer.dart';

class CarouselUpcomingCourse extends StatelessWidget {
  final UpComingCoursesController upCoursesController =
      Get.put(UpComingCoursesController());

  CarouselUpcomingCourse({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return StreamBuilder<QuerySnapshot>(
      stream: upCoursesController.upComingCourses.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: mediaQuery.screenWidth,
            height: mediaQuery.screenHeight * 0.4,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.grey[300],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading courses.'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            width: mediaQuery.screenWidth,
            height: mediaQuery.screenHeight * 0.4,
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: const Center(child: Text('No upcoming courses')),
          );
        }

        final upCominCourse = snapshot.data!.docs.map((doc) {
          return UpcomingCourseModel.fromDocument(doc);
        }).toList();

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
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: false,
                                    context: context,
                                    builder: (context) => EditUpcomingCourses(
                                        upComingCourseId: upCourses.id,
                                        newUpComingCourseName:
                                            upCourses.upcomingCourseName,
                                        newUpComingCourseDetails:
                                            upCourses.upComingCourseDetails,
                                        newUpComingCourseImage:
                                            upCourses.upComingCourseImage));
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Are you sure'),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text('No'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await upCoursesController
                                                  .deleteUpcomingCourse(
                                                      upCourses.id, context);
                                              Get.back();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
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
      },
    );
  }

  Widget _displayImage(String imagePath) {
    const double aspectRatio = 1 / 1;

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
                    child: Container(color: Colors.grey[300]),
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
}
