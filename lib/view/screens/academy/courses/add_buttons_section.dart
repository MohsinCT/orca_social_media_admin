// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:orca_social_media_admin/constants/media_query.dart';
// import 'package:orca_social_media_admin/controller/Firebase/course_controller.dart';
// import 'package:orca_social_media_admin/controller/web/loading_controller.dart';
// import 'package:orca_social_media_admin/view/widgets/custom_add_button.dart';

// class AddButtonsSection extends StatelessWidget {
//   final CourseController courseController;
//   final LoadingController loadingController;
//   const AddButtonsSection(
//       {super.key,
//       required this.courseController,
//       required this.loadingController});

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQueryHelper(context);
//     return Row(children: [
//       CustomAddButton(text: 'Add Course', onTap: () {}),
//       SizedBox(
//         width: mediaQuery.screenWidth * 0.01,
//       ),
//       CustomAddButton(text: 'AddUpcomingCourses', onTap: () {}),
//     ]);
//   }

//   void showAddCourseDialog(BuildContext context) {
//     final TextEditingController courseNameController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           contentPadding: const EdgeInsets.all(16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           title: const Text(
//             'Add New Course',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: () async {
//                     loadingController.setLoadingForCourseImage(true);
//                     await courseController.pickimage(ImageSource.gallery);
//                     loadingController.setLoadingForCourseImage(false);
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     height: 150,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey),
//                     ),
//                     child: Obx(() {
//                       if (loadingController.isLoadingForCourseImage.value) {
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }
//                       return courseController.imagePath.isNotEmpty
//                           ? _displayImage(courseController.imagePath.value)
//                           : const Icon(
//                               Icons.add_a_photo,
//                               size: 50,
//                               color: Colors.grey,
//                             );
//                     }),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Text field for adding course name
//                 TextFormField(
//                   controller: courseNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Course Name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Add Button
//                 Row(
//                   children: [
//                     ElevatedButton(
//                         onPressed: () {
//                           courseController.courseName.clear();
//                           courseController.resetImage();
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('Clear')),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (courseNameController.text.isNotEmpty &&
//                             courseController.imagePath.isNotEmpty) {
//                           // Add course to the list with image
//                           courseController.addNewCourse(context);
//                           courseController.resetImage();
//                           Navigator.of(context).pop(); // Close the dialog
//                         }
//                       },
//                       child: const Text('Add'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _displayImage(String imagePath) {
//     if (imagePath.isEmpty) {
//       // Show default image when no image is picked
//       return Image.asset('assets/cube-1963300_640.jpg', fit: BoxFit.cover);
//     } else if (kIsWeb) {
//       // Web: Display image from base64
//       return Image.memory(base64Decode(imagePath), fit: BoxFit.cover);
//     } else {
//       // Non-web: Display image from file
//       return Image.file(File(imagePath), fit: BoxFit.cover);
//     }
//   }
// }
