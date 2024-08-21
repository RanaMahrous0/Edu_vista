import 'package:flutter/material.dart';
import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/lecture_card_widget.dart';
import 'package:task6_adv/widgets/my_label_text.dart';

class CourseDetailsWidget extends StatefulWidget {
  final Map<String, dynamic> courseData;
  const CourseDetailsWidget({required this.courseData, super.key});

  @override
  State<CourseDetailsWidget> createState() => _CourseDetailsWidgetState();
}

class _CourseDetailsWidgetState extends State<CourseDetailsWidget> {
  String selectedButton = 'Lecture';
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
                MyLabelText(fontSize: 20, text: widget.courseData['title']),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.courseData['instructor']['name'],
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
                      elevButton('Download'),
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
          selectedButton == 'Lecture'
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 17,
                    mainAxisSpacing: 17,
                    children: List.generate(7, (index) {
                      return LectureCard(
                          title: 'Lecture${index + 1}',
                          description: 'description${index + 1}',
                          duration: '10',
                          isFirst: index == 0);
                    }),
                  ),
                )
              : Center(
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
}
