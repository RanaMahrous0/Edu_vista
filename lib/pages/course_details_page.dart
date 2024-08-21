import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task6_adv/pages/home_page.dart';
import 'package:task6_adv/widgets/course_details_widget.dart';

class CourseDetailsPage extends StatefulWidget {
  static const String id = 'LoginPage';
  final String courseId;
  const CourseDetailsPage({required this.courseId, super.key});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  Future<Map<String, dynamic>> fetchCourseDetails() async {
    DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .get();

    if (courseSnapshot.exists) {
      return courseSnapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Course not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, HomePage.id);
            },
          ),
        ),
        body: FutureBuilder(
          future: fetchCourseDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final courseData = snapshot.data!;
              return CourseDetailsWidget(courseData: courseData);
            } else {
              return const Center(child: Text('No course found'));
            }
          },
        ));
  }
}
