import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';
import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
import 'package:orca_social_media_admin/controller/web/loading_controller.dart';
import 'package:orca_social_media_admin/model/course_category_model.dart';
import 'package:orca_social_media_admin/model/course_model.dart';
import 'package:orca_social_media_admin/view/screens/academy/course_category.dart/lessons.dart';
import 'package:orca_social_media_admin/view/screens/academy/courses/add_course_categories.dart';
import 'package:orca_social_media_admin/view/widgets/custom_add_button.dart';

// ignore: avoid_web_libraries_in_flutter
import 'package:shimmer/shimmer.dart';

class CourseCategories extends StatelessWidget {
  CourseCategories({
    super.key,
  });

  final CourseController courseController = Get.find();
  final LoadingController loadingController = Get.find();

  late final CourseCategoryModel courseCategoryModel;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    final data = Get.parameters['data'];
    late CourseModel course;
    if (data != null) {
      final decodedData = Uri.decodeComponent(data);
      try {
        course = CourseModel.fromJson(jsonDecode(decodedData));
      } catch (e) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Invalid course categories data.')),
        );
      }
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No CategoryCourse are provided.')),
      );
    }
    courseController.getCategoriesStream(course.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(children: [
        CustomAddButton(
          text: 'Add Category',
          onTap: () => showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => AddCourseCategories(
              courseid: course.id,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: courseController.getCategoriesStream(course.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No Categories'),
                );
              }

              final categories = snapshot.data!.docs
                  .map((doc) => CourseCategoryModel.fromDocument(doc))
                  .toList();

              return GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.screenWidth * 0.03,
                  vertical: mediaQuery.screenWidth * 0.02,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: mediaQuery.isLarger
                      ? 3
                      : mediaQuery.isMedium
                          ? 2
                          : 1, // Number of columns
                  crossAxisSpacing: mediaQuery.screenWidth * 0.03,
                  mainAxisSpacing: mediaQuery.screenWidth * 0.03,
                  childAspectRatio: mediaQuery.isLarger
                      ? 1.4
                      : mediaQuery.isMedium
                          ? 1.5
                          : 2.8, // Adjust for card dimensions
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 239, 229, 229),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: mediaQuery.screenWidth * 0.01),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              width: mediaQuery.screenWidth * 0.5,
                              height: mediaQuery.screenHeight * 0.17,
                              child: _displayImage(category.categoryImage),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            category.categoryName,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          trailing: Text('Lessons ${category.lessonCount}'),
                        ),
                        ListTile(
                          title: Text(
                            category.categoryCourseName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showEditCourseCategoryDialog(
                                    context: context,
                                    mediaQuery: mediaQuery,
                                    loadingController: loadingController,
                                    courseController: courseController,
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
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
                                                    await courseController
                                                        .deleteCategory(
                                                            context,
                                                            course.id,
                                                            category.id);
                                                    Get.back();

                                                  },
                                                  child: const Text('Yes'))
                                            ],
                                          ),
                                        );
                                      });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                              // DeleteButton(
                              //     content:
                              //         'This Action will permanently delete the category',
                              //     onPressed: () async {
                              //       await courseController.deleteCategory(
                              //           context, course.id, category.id);

                              //       Get.back();
                                  
                              //     })
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => Lessons(
                                  courseId: course.id,
                                  categoryId: category.id,
                                ));
                          },
                          child: const Text('OPEN'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        )
      ]),
    );
  }
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

void showEditCourseCategoryDialog({
  required BuildContext context,
  required MediaQueryHelper mediaQuery,
  required LoadingController loadingController,
  required CourseController courseController,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          'Edit Course Category',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  loadingController.setLoadingForCategory(true);
                  await courseController
                      .pickimageForCategory(ImageSource.gallery);
                  loadingController.setLoadingForCategory(false);
                },
                child: Obx(() {
                  return Container(
                    width: mediaQuery.screenWidth * 0.3,
                    height: mediaQuery.screenHeight * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: loadingController.isLoadingForCategoryImage.value
                        ? const Center(child: CircularProgressIndicator())
                        : courseController.categoryImage.isNotEmpty
                            ? Image.memory(
                                base64Decode(
                                    courseController.categoryImage.value),
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey,
                              ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: courseController.categoryBasedCourseName,
                decoration: const InputDecoration(
                  labelText: 'Category based Course Name',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // Row with Category and Lessons fields
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: courseController.categoryName,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: courseController.lessonsCount,
                      decoration: const InputDecoration(
                        labelText: 'Lessons',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
