import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orca_social_media_admin/model/upcoming_course_model.dart';

class UpComingCoursesController extends GetxController {
  final TextEditingController courseName = TextEditingController();
  final TextEditingController courseDetails = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  var upComingCourseList = <UpcomingCourseModel>[].obs;
  var imagePath = ''.obs;

  final CollectionReference upComingCourses =
      FirebaseFirestore.instance.collection('upComingCourse');

  @override
  void onInit() {
     fetchUpcomingCourses();
    super.onInit();
   
  }

  void updateImagePath(String path) {
    imagePath.value = path;
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      if (kIsWeb) {
        var bytes = await pickedFile.readAsBytes();
        updateImagePath(base64Encode(bytes));
      } else {
        updateImagePath(pickedFile.path);
      }
    }
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

  // ----------Fetch-----------

 Future<void> fetchUpcomingCourses() async {
  try {
    QuerySnapshot snapshot = await upComingCourses.get();

    // Parse each document into UpcomingCourseModel
    upComingCourseList.value = snapshot.docs.map((doc) {
      try {
        return UpcomingCourseModel.fromDocument(doc);
      } catch (e) {
        log('Error parsing document ${doc.id}: $e');
        return null; // Skip documents that cause errors
      }
    }).where((course) => course != null).cast<UpcomingCourseModel>().toList();

    log('Fetched ${upComingCourseList.length} upcoming courses.');
  } catch (e) {
    log('Failed to fetch upcoming courses: $e');
  }
}



  // ----------Create-----------

  Future<void> addUpcomingCourses(BuildContext context) async {
    try {
      String id = upComingCourses.doc().id;
      String? imageUrl = await uploadImageToFirebase();

      UpcomingCourseModel newCourse = UpcomingCourseModel(
        id: id,
        upComingCourseImage: imageUrl ?? '',
        upcomingCourseName: courseName.text,
        upComingCourseDetails: courseDetails.text,
      );

      await upComingCourses.doc(id).set(newCourse.toMap());

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course added successfully.')),
      );
    } catch (e) {
      log('Error upcoming $e');
      
    }
  }

  void resetImage() {
    imagePath.value = '';
  }

  // ----------Edit-----------

  Future<void> editUpcomingCourse(String id, BuildContext context) async {
    try {
      String? imageUrl;
      if (imagePath.value.isNotEmpty) {
        imageUrl = await uploadImageToFirebase();
      }

      Map<String, dynamic> updateData = {
        'UpcomingCourseName': courseName.text,
        'UpComingCourseDetails': courseDetails.text,
      };

      if (imageUrl != null) {
        updateData['UpcomingCourseImage'] = imageUrl;
      }

      await upComingCourses.doc(id).update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course updated successfully.')),
      );
    } catch (e) {
      log('Error upcoming $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // ------------Delete------------

  Future<void> deleteUpcomingCourse(String id, BuildContext context) async {
    try {
      await upComingCourses.doc(id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
