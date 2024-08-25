import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:task6_adv/models/course.dart';
import 'package:task6_adv/models/lecture.dart';
import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/lecture_card_widget.dart';
import 'package:task6_adv/widgets/my_label_text.dart';

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
  String? selectedLectureId;
  String? certificateImageUrl;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://media.istockphoto.com/id/537331500/photo/programming-code-abstract-technology-background-of-software-deve.jpg?s=612x612&w=0&k=20&c=jlYes8ZfnCmD0lLn-vKvzQoKXrWaEcVypHnB5MuO-g8='),
                    fit: BoxFit.cover)),
            child: const Center(
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 80,
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyLabelText(
                    fontSize: 20, text: widget.courseData.title ?? 'no title'),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.courseData.instructor!.name ?? 'no name',
                  style: const TextStyle(
                      color: Color(0xff1D1B20),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 17,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      elevButton('Lecture'),
                      const SizedBox(
                        width: 10,
                      ),
                      elevButton('Upload'),
                      const SizedBox(
                        width: 10,
                      ),
                      elevButton('Certificate'),
                      const SizedBox(
                        width: 10,
                      ),
                      elevButton('More')
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 17,
          ),
          if (selectedButton == 'Lecture')
            Padding(
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
                    title: lecture.title ?? 'No Title',
                    description: lecture.description ?? 'No Description',
                    duration: lecture.duration.toString(),
                    lectureUrl: lecture.lectureUrl ?? 'No Url',
                  );
                },
              ),
            )
          else if (selectedButton == 'Upload')
            certificateImageUrl == null
                ? ElevatedButton(
                    onPressed: () async {
                      await uploadCertificate();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorUtility.secondry,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Upload Certificate'),
                  )
                : Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Image.network(certificateImageUrl!),
                  )
          else
            Center(
              child: Text(selectedButton),
            )
        ],
      ),
    );
  }

  Widget elevButton(String buttonText) {
    bool isSelected = selectedButton == buttonText;
    return ElevatedButton(
      onPressed: () {
        setState(
          () {
            selectedButton = buttonText;
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? ColorUtility.secondry : const Color(0xffEBEBEB),
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(buttonText),
    );
  }

  Future<void> uploadCertificate() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      Reference storageRef =
          FirebaseStorage.instance.ref().child('certificates/$fileName');

      try {
        // Upload the file
        await storageRef.putFile(file);
        String downloadUrl = await storageRef.getDownloadURL();
        setState(() {
          certificateImageUrl = downloadUrl;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Certificate uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload certificate: $e')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No certificate selected')),
        );
      }
    }
  }
}
