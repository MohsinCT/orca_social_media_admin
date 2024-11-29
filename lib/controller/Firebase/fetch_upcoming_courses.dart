import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FetchUpcomingCourses extends GetxController {
  final CollectionReference upComingCourses =
      FirebaseFirestore.instance.collection('upComingCourse');

  RxList<Map<String, dynamic>> upComingCourseList = <Map<String, dynamic>>[].obs;


  Future<void> fetchUpcomingCourses() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('upComingCourse').get();
      upComingCourseList.value = snapshot.docs.map((doc) {
        return {
          'image': doc['image'],
          'courseName': doc['courseName'],
          'courseDetails': doc['courseDetails']
        };
      }).toList();
    } catch (e) {
      log('Error und................... $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingCourses();
  }
}
