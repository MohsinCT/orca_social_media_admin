import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orca_social_media_admin/model/course_category_model.dart';
import 'package:orca_social_media_admin/model/course_model.dart';
import 'package:orca_social_media_admin/model/lesson_model.dart';

class CourseController extends GetxController {
  final ImagePicker imagePicker = ImagePicker();
  TextEditingController courseName = TextEditingController();
  TextEditingController categoryName = TextEditingController();
  TextEditingController categoryBasedCourseName = TextEditingController();
  TextEditingController lessonsCount = TextEditingController();
  TextEditingController lessonName = TextEditingController();
  var courseList = <CourseModel>[].obs;
  var categories = <CourseCategoryModel>[].obs;
  var imagePath = ''.obs;
  var videoPath = ''.obs;
  var categoryImage = ''.obs;
  var lessonNameObs = ''.obs;
  var filteredCourses = <CourseModel>[].obs;

  void updateLesssonName() {
    lessonNameObs.value = lessonName.text;
  }

  final CollectionReference newCourse =
      FirebaseFirestore.instance.collection('NewCourse');

  @override
  void onInit() {
    fetchNewCourses(); // Fetch courses when the controller is initialized
    super.onInit();
    filteredCourses.value = courseList;
  }

  //-------------------------SearchCourses----------------------------

  void searchCourses(String query) {
    if (query.isEmpty) {
      filteredCourses.value = courseList;
    } else {
      filteredCourses.value = courseList
          .where((course) =>
              course.courseName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  //-------------------------courseImage----------------------------

  void updateImagePath(String path) {
    imagePath.value = path;
  }

  Future<void> pickimage(ImageSource source) async {
    final pickerFile = await imagePicker.pickImage(source: source);
    if (pickerFile != null) {
      if (kIsWeb) {
        var bytes = await pickerFile.readAsBytes();
        updateImagePath(base64Encode(bytes));
      } else {
        updateImagePath(pickerFile.path);
      }
    }
  }

  void resetImage() {
    imagePath.value = '';
    categoryImage.value = '';
  }

  Future<String?> uploadImageToFirebase() async {
    try {
      if (imagePath.isEmpty) return null;

      String fileName;
      Reference ref;
      UploadTask uploadTask;

      if (kIsWeb) {
        Uint8List bytes = base64Decode(imagePath.value);
        fileName = 'web_image_${DateTime.now().millisecondsSinceEpoch}.png';
        ref = FirebaseStorage.instance.ref().child('my_Images/$fileName');
        uploadTask = ref.putData(bytes);
      } else {
        fileName = imagePath.value.split('/').last;
        ref = FirebaseStorage.instance.ref().child('my_Images/$fileName');
        uploadTask = ref.putFile(File(imagePath.value));
      }

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        log('Image upload complete');
      });

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log('Image upload failed: $e');
      return null;
    }
  }

  // ------------------------CategoryImage--------------------

  Future<void> pickimageForCategory(ImageSource source) async {
    final pickerFile = await imagePicker.pickImage(source: source);
    if (pickerFile != null) {
      if (kIsWeb) {
        var bytes = await pickerFile.readAsBytes();
        updateCategoryImage(base64Encode(bytes));
      } else {
        updateCategoryImage(pickerFile.path);
      }
    }
  }

  void updateCategoryImage(String path) {
    categoryImage.value = path;
  }

  Future<String?> uploadCategoryImageToFirebase() async {
    try {
      if (categoryImage.isEmpty) return null;

      String fileName;
      Reference ref;
      UploadTask uploadTask;

      if (kIsWeb) {
        Uint8List bytes = base64Decode(categoryImage.value);
        fileName = 'web_image_${DateTime.now().millisecondsSinceEpoch}.png';
        ref = FirebaseStorage.instance.ref().child('my_Images/$fileName');
        uploadTask = ref.putData(bytes);
      } else {
        fileName = categoryImage.value.split('/').last;
        ref = FirebaseStorage.instance.ref().child('my_Images/$fileName');
        uploadTask = ref.putFile(File(categoryImage.value));
      }

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        log('Image upload complete');
      });

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log('Image upload failed: $e');
      return null;
    }
  }

  void resetCategoryImage() {
    categoryImage.value = '';
  }

  //-------------------------Video----------------------------
  void updateVideo(String path) {
    videoPath.value = path;
  }

  Future<void> pickLessonVideo(ImageSource source) async {
    final pickedVideo = await imagePicker.pickVideo(source: source);
    if (pickedVideo != null) {
      if (kIsWeb) {
        var bytes = await pickedVideo.readAsBytes();
        // Store bytes directly for web, without base64 encoding
        videoBytes = bytes;
        videoPath.value =
            'web_video_selected'; // Indicator that video is selected
      } else {
        updateVideo(pickedVideo.path);
      }
    }
  }

  Future<String?> uploadVideoToFirebase() async {
    try {
      if (videoPath.isEmpty) return null;

      String fileName = videoPath.value.split('/').last;
      Reference ref =
          FirebaseStorage.instance.ref().child('my_Videos/$fileName');
      UploadTask uploadTask;

      if (kIsWeb && videoBytes != null) {
        // Use videoBytes directly for web upload
        uploadTask = ref.putData(videoBytes!);
      } else {
        // Upload file directly for mobile
        uploadTask = ref.putFile(File(videoPath.value));
      }

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        log('Video upload complete');
      });

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log('Video upload failed: $e');
      return null;
    }
  }

  void resetVideo() {
    videoPath.value = '';
    videoBytes = null; // Clear bytes as well for web
  }

// You also need to declare videoBytes as an Rx variable for Web
  Uint8List? videoBytes;

//-------------------------CRUD----------------------------

//-------------------------NewCourse----------------------------

  Future<void> fetchNewCourses() async {
    try {
      FirebaseFirestore.instance
          .collection('NewCourse') // Your Firestore collection name
          .snapshots() // Listen for real-time updates
          .listen((QuerySnapshot querySnapshot) {
        // Map the documents to CourseModel and update the observable list
        courseList.value = querySnapshot.docs
            .map((doc) => CourseModel.fromDocument(doc))
            .toList();
      });
    } catch (e) {
      log('Error in fetchNewCourses: $e');
    }
  }

  Future<void> addNewCourse(BuildContext context) async {
    try {
      String id = newCourse.doc().id;
      String? imageUrl = await uploadImageToFirebase();

      if (imageUrl != null) {
        CourseModel course = CourseModel(
          id: id,
          courseName: courseName.text,
          imagePath: imageUrl,
        );

        await newCourse.doc(id).set(course.toMap());
        log('course added');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('New Course add check in user side'),
          backgroundColor: Colors.green,
        ));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Image upload failed')));
        log('faild to upload image');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('errro und........$e')));
    }
  }

  Future<void> updateCourse(BuildContext context, String courseId) async {
    try {
      String? imageUrl;
      if (imagePath.isNotEmpty) {
        imageUrl = await uploadImageToFirebase();
      }
      DocumentSnapshot courseDoc = await newCourse.doc(courseId).get();

      if (courseDoc.exists) {
        Map<String, dynamic> existingData =
            courseDoc.data() as Map<String, dynamic>;

        CourseModel updatedCourse = CourseModel(
          id: courseId,
          courseName: courseName.text.isNotEmpty
              ? courseName.text
              : existingData['courseName'],
          imagePath: imageUrl ?? existingData['image'],
        );
        await newCourse.doc(courseId).update(updatedCourse.toMap());
        log('Course updated');

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Course updated successfully'),
          backgroundColor: Colors.green,
        ));
      } else {
        // Handle the case where the document does not exist
        log('Course not found');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Course not found'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      log('Error updating course: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating course: $e')),
      );
    }
  }

  Future<void> deleteCourse(String id, BuildContext context) async {
    try {
      await newCourse.doc(id).delete();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('course delete succesfull')));
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

//-------------------------CourseCategory----------------------------

   Stream<QuerySnapshot> getCategoriesStream(String courseId) {
  DocumentReference courseRef = newCourse.doc(courseId);
  return courseRef.collection('Categories').snapshots();
}


  Future<void> addCategoryCourse(BuildContext context, String courseId) async {
    try {
      String? categoryImageUrl = await uploadCategoryImageToFirebase();

      if (categoryImageUrl != null) {
        // Reference to the course document
        DocumentReference courseRef = newCourse.doc(courseId);

        // Generate a unique ID for the new category
        String categoryId = courseRef.collection('Categories').doc().id;

        // Create the category object
        CourseCategoryModel category = CourseCategoryModel(
          id: categoryId,
          categoryImage: categoryImageUrl,
          categoryName: categoryName.text,
          lessonCount: int.tryParse(lessonsCount.text) ?? 0,
          categoryCourseName: categoryBasedCourseName.text,
        );

        // Add the category as a subcollection under the specified course
        await courseRef
            .collection('Categories')
            .doc(categoryId)
            .set(category.toMap());
        log('Category added successfully to course $courseId');

        // Show success message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Category added successfully'),
          backgroundColor: Colors.green,
        ));

        // Clear input fields after adding
        categoryName.clear();
        lessonsCount.clear();
        categoryBasedCourseName.clear();
        resetCategoryImage();
      } else {
        // Handle image upload failure
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to upload category image'),
          backgroundColor: Colors.red,
        ));
        log('Category image upload failed');
      }
    } catch (e) {
      // Handle errors
      log('Failed to add category: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error adding category: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

Future<void> editCategoryCourse(
    BuildContext context, String courseId, String categoryId) async {
  try {
    // Reference to the specific category document
    DocumentReference categoryRef =
        newCourse.doc(courseId).collection('Categories').doc(categoryId);

    // Upload new category image if it has been changed
    String? newCategoryImageUrl;
    if (imagePath.value.isNotEmpty) {
      newCategoryImageUrl = await uploadCategoryImageToFirebase();
    }

    // Create a map of the updated data
    Map<String, dynamic> updatedData = {
      'categoryImage':categoryImage.value,
      'categoryName': categoryName.text,
      'lessonCount': int.tryParse(lessonsCount.text) ?? 0,
      'categoryCourseName': categoryBasedCourseName.text,
    };

    // Only update the image if a new one was uploaded
    if (newCategoryImageUrl != null) {
      updatedData['categoryImage'] = newCategoryImageUrl;
    }

    // Update the category document
    await categoryRef.update(updatedData);

    log('Category updated successfully: $categoryId');

    // Show success message
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Category updated successfully'),
      backgroundColor: Colors.green,
    ));

    // Clear input fields after updating
    categoryName.clear();
    lessonsCount.clear();
    categoryBasedCourseName.clear();
    resetCategoryImage();
  } catch (e) {
    // Handle errors
    log('Failed to update category: $e');
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error updating category: $e'),
      backgroundColor: Colors.red,
    ));
  }
}

  Future<void> deleteCategory(
      BuildContext context, String courseId, String categoryId) async {
    try {
      // Reference to the specific category document
      DocumentReference categoryRef =
          newCourse.doc(courseId).collection('Categories').doc(categoryId);

      // Delete the category document
      await categoryRef.delete();

      log('Category deleted successfully from course $courseId');

      // Show success message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Category deleted successfully'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      // Handle errors
      log('Failed to delete category: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting category: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

//-------------------------Lessons----------------------------

  Stream<List<LessonModel>> fetchLessons(String courseId, String categoryId) {
    return FirebaseFirestore.instance
        .collection('NewCourse')
        .doc(courseId)
        .collection('Categories')
        .doc(categoryId)
        .collection('Lessons')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => LessonModel.fromDocument(doc)).toList();
    });
  }

  Future<void> addLessonsToCategory(
      BuildContext context, String courseId, String categoryId) async {
    try {
      String? videoUrl = await uploadVideoToFirebase();

      if (videoUrl != null) {
        DocumentReference categoryRef = FirebaseFirestore.instance
            .collection('NewCourse')
            .doc(courseId)
            .collection('Categories')
            .doc(categoryId);

        String lessonId = categoryRef.collection('Lessons').doc().id;

        LessonModel lesson = LessonModel(
            id: lessonId, lessonVideo: videoUrl, lessonName: lessonName.text);

        await categoryRef
            .collection('Lessons')
            .doc(lessonId)
            .set(lesson.toMap());
        log('lesson added successfully...........');
        lessonName.clear();
        resetVideo();
      } else {
        log('Video upload failed');
      }
    } catch (e) {
      log('failed to add lesson $e');
    }
  }
}
