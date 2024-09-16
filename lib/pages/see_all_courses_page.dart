import 'package:flutter/material.dart';
import 'package:task6_adv/widgets/homePage/course_widget.dart';
import 'package:task6_adv/widgets/homePage/viewed_course_widget.dart';

class SeeAllCoursesPage extends StatefulWidget {
  final String filiteredBy;
  const SeeAllCoursesPage({required this.filiteredBy, super.key});

  @override
  State<SeeAllCoursesPage> createState() => _SeeAllCoursesPageState();
}

class _SeeAllCoursesPageState extends State<SeeAllCoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.filiteredBy),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            widget.filiteredBy == 'Because you viewed'
                ? const ViewedCoursesWidget(seeAll: true,)
                : CoursesWidget(seeAll: true, rankValue: widget.filiteredBy),
          ],
        ),
      ),
    );
  }
}
