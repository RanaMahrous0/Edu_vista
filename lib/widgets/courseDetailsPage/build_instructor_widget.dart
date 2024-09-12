import 'package:flutter/material.dart';
import 'package:task6_adv/models/course.dart';
import 'package:task6_adv/utility/color_utility.dart';

class BuildInstructorWidget extends StatelessWidget {
  final Course courseData;
  const BuildInstructorWidget({required this.courseData,super.key});

  @override
  Widget build(BuildContext context) {
     final instructor = courseData.instructor;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: ColorUtility.whiteGray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              instructor?.name ?? 'No Name',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(instructor?.graduatedForm ?? 'No bio available.'),
            const SizedBox(height: 8),
            Text('Experience: ${instructor?.yearsOfExperience ?? 'N/A'} years'),
          ],
        ),
      ),
    );
  }
}