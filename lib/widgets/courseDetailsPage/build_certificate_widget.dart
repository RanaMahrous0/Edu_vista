import 'package:flutter/material.dart';
import 'package:task6_adv/models/course.dart';
import 'package:task6_adv/utility/color_utility.dart';

class BuildCertificateWidget extends StatelessWidget {
  final Course courseData;
  const BuildCertificateWidget({required this.courseData,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Certificate of Completion',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorUtility.secondry,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This certifies that',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              courseData.instructor?.name ?? 'No Name',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Has successfully completed the course:',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              courseData.title ?? 'No Title',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorUtility.secondry,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Date: ${DateTime.now().toLocal()}',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Signature',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );;
  }
}