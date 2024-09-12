import 'package:flutter/material.dart';
import 'package:task6_adv/models/course.dart';
import 'package:task6_adv/models/lecture.dart';
import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/courseDetailsPage/build_certificate_widget.dart';
import 'package:task6_adv/widgets/courseDetailsPage/build_instructor_widget.dart';
import 'package:task6_adv/widgets/lecture_card_widget.dart';
import 'package:task6_adv/widgets/my_label_text.dart';
import 'package:task6_adv/widgets/video_box_widget.dart';

class CourseDetailsWidget extends StatefulWidget {
  final Course courseData;
  final List<Lecture> lectures;

  const CourseDetailsWidget(
      {required this.lectures, required this.courseData, super.key});

  @override
  State<CourseDetailsWidget> createState() => _CourseDetailsWidgetState();
}

class _CourseDetailsWidgetState extends State<CourseDetailsWidget> {
  String selectedButton = 'Lecture';
  int? selectedLectureIndex;
  bool showInstructorInfo = false;
  bool showCourseResources = false;
  bool showShareCourse = false;

  @override
  Widget build(BuildContext context) {
    String? selectedLectureUrl = selectedLectureIndex != null
        ? widget.lectures[selectedLectureIndex!].lectureUrl
        : null;

    return SingleChildScrollView(
      child: Column(
        children: [
          VideoBoxWidget(url: selectedLectureUrl ?? ''),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyLabelText(
                    fontSize: 20, text: widget.courseData.title ?? 'No title'),
                const SizedBox(height: 10),
                Text(
                  widget.courseData.instructor!.name ?? 'No name',
                  style: const TextStyle(
                      color: Color(0xff1D1B20),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 17),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      elevButton('Lecture'),
                      const SizedBox(width: 10),
                      elevButton('Download'),
                      const SizedBox(width: 10),
                      elevButton('Certificate'),
                      const SizedBox(width: 10),
                      elevButton('More'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          if (selectedButton == 'Lecture')
            lectureOptionWidget()
          else if (selectedButton == 'More')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  moreOptionWidget('About instructor', toggleInstructorInfo,
                      showInstructorInfo),
                  if (showInstructorInfo)
                    BuildInstructorWidget(
                      courseData: widget.courseData,
                    ),
                  moreOptionWidget('Course Resources', toggleCourseResources,
                      showCourseResources),
                  if (showCourseResources) buildCourseResources(),
                  moreOptionWidget(
                      'Share this Course', toggleShareCourse, showShareCourse),
                  if (showShareCourse) buildShareCourse(),
                ],
              ),
            )
          else if (selectedButton == 'Certificate')
            BuildCertificateWidget(
              courseData: widget.courseData,
            )
          else if (selectedButton == 'Download')
            downloadOptionWidget()
        ],
      ),
    );
  }

  Widget lectureOptionWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 17,
          mainAxisSpacing: 17,
        ),
        itemCount: widget.lectures.length,
        itemBuilder: (context, index) {
          var lecture = widget.lectures[index];
          return LectureCard(
            onTap: () {
              setState(() {
                selectedLectureIndex = index;
              });
              print(widget.lectures[selectedLectureIndex!].lectureUrl);
            },
            isSelected: selectedLectureIndex == index,
            title: lecture.title ?? 'No Title',
            description: lecture.description ?? 'No Description',
            duration: lecture.duration.toString(),
            lectureUrl: lecture.lectureUrl ?? 'No Url',
            courseId: widget.courseData.id ?? '',
            isDownloaded: false,
          );
        },
      ),
    );
  }

  Widget downloadOptionWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 17,
          mainAxisSpacing: 17,
        ),
        itemCount: widget.lectures.length,
        itemBuilder: (context, index) {
          var lecture = widget.lectures[index];
          return LectureCard(
            onTap: () {
              setState(() {
                selectedLectureIndex = index;
              });
              print(widget.lectures[selectedLectureIndex!].lectureUrl);
            },
            isSelected: selectedLectureIndex == index,
            title: lecture.title ?? 'No Title',
            description: lecture.description ?? 'No Description',
            duration: lecture.duration.toString(),
            lectureUrl: lecture.lectureUrl ?? 'No Url',
            courseId: widget.courseData.id ?? '',
            isDownloaded: true,
          );
        },
      ),
    );
  }

  Widget moreOptionWidget(
      String title, void Function() onTap, bool isExpanded) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(title),
        trailing: Icon(
          isExpanded
              ? Icons.keyboard_double_arrow_down
              : Icons.keyboard_double_arrow_right,
          color: isExpanded ? ColorUtility.secondry : Colors.black,
        ),
        tileColor: ColorUtility.whiteGray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: onTap,
      ),
    );
  }

  Widget elevButton(String buttonText) {
    bool isSelected = selectedButton == buttonText;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedButton = buttonText;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? ColorUtility.secondry : const Color(0xffEBEBEB),
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(buttonText),
    );
  }

  // Toggle instructor information
  void toggleInstructorInfo() {
    setState(() {
      showInstructorInfo = !showInstructorInfo;
    });
  }

  // Build instructor information container

  // Toggle course resources information
  void toggleCourseResources() {
    setState(() {
      showCourseResources = !showCourseResources;
    });
  }

  // Build course resources container
  Widget buildCourseResources() {
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
              'Course Resources',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Resource details here...'),
          ],
        ),
      ),
    );
  }

  // Toggle share course information
  void toggleShareCourse() {
    setState(() {
      showShareCourse = !showShareCourse;
    });
  }

  // Build share course container
  Widget buildShareCourse() {
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
              'Share this Course',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Share details or options here...'),
          ],
        ),
      ),
    );
  }
}
