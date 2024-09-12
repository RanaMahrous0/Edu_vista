import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task6_adv/models/course.dart';
import 'package:task6_adv/pages/course_details_page.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  List<String> filteredItem = ['All', 'Downloaded'];
  String selectedFilter = 'All';
  late Future<List<Course>> futureCourses;

  @override
  void initState() {
    super.initState();
    futureCourses = _fetchCourses('All');
  }

  Future<List<Course>> _fetchCourses(String filter) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot;

      if (filter == 'Downloaded') {
        // For now, we'll show the local image instead of fetching data
        return [];
      } else {
        querySnapshot =
            await FirebaseFirestore.instance.collection('courses').get();
        return querySnapshot.docs
            .map((doc) => Course.fromJson({'id': doc.id, ...doc.data()}))
            .toList();
      }
    } catch (error) {
      print('Error fetching courses: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filteredItem.length,
              separatorBuilder: (context, index) => const SizedBox(width: 20),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilter = filteredItem[index];
                    if (selectedFilter == 'Downloaded') {
                      // We don't fetch courses; instead, we'll show the image
                    } else {
                      futureCourses = _fetchCourses(selectedFilter);
                    }
                  });
                },
                child: MyChipCourseWidget(
                  label: Text(filteredItem[index]),
                  isSelected: filteredItem[index] == selectedFilter,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: selectedFilter == 'Downloaded'
              ? Center(
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.asset(
                        'assets/images/Frame.png'), // Local image path
                  ),
                )
              : FutureBuilder<List<Course>>(
                  future: futureCourses,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      print('Error loading courses: ${snapshot.error}');
                      return Center(child: Text('Error loading courses'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No Courses Found'));
                    }

                    var courses = snapshot.data!;

                    return ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];

                        return ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: Image.network(
                            course.image ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(course.title ?? 'No Title'),
                          subtitle: Text('\$${course.price}'),
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CourseDetailsPage(
                                        courseId: course.id ?? '')));
                          },
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class MyChipCourseWidget extends StatelessWidget {
  final Widget label;
  final bool
      isSelected; // Add this parameter to indicate if the chip is selected

  const MyChipCourseWidget({
    required this.label,
    this.isSelected = false, // Default value for isSelected is false
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: label,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      backgroundColor:
          isSelected ? const Color(0xffB0BEC5) : const Color(0xffE0E0E0),
      // Change the background color based on whether the chip is selected
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
      // Change the text color based on whether the chip is selected
    );
  }
}
