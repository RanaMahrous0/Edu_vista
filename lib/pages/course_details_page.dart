import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/blocs/course/bloc/course_bloc.dart';
import 'package:task6_adv/blocs/course/bloc/course_state.dart';
import 'package:task6_adv/blocs/lecture/bloc/lecture_bloc.dart';
import 'package:task6_adv/blocs/lecture/bloc/lecture_event.dart';
import 'package:task6_adv/blocs/lecture/bloc/lecture_state.dart';
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
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                CourseBloc()..add(LoadCourseEvent(widget.courseId)),
          ),
          BlocProvider(
            create: (context) =>
                LectureBloc()..add(LoadLecturesEvent(widget.courseId)),
          ),
        ],
        child: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, courseState) {
            if (courseState is CourseLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (courseState is CourseError) {
              return Center(child: Text('Error: ${courseState.message}'));
            } else if (courseState is CourseLoaded) {
              return BlocBuilder<LectureBloc, LectureState>(
                builder: (context, lectureState) {
                  if (lectureState is LectureLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (lectureState is LectureError) {
                    print('Error: ${lectureState.message}');
                    return Center(
                        child: Text('Error: ${lectureState.message}'));
                  } else if (lectureState is LectureLoaded) {
                    print('Lectures loaded: ${lectureState.lectures.length}');
                    return CourseDetailsWidget(
                      courseData: courseState.course,
                      lectures: lectureState.lectures,
                    );
                  } else {
                    return const Center(child: Text('No lectures found'));
                  }
                },
              );
            } else {
              return const Center(child: Text('No course found'));
            }
          },
        ),
      ),
    );
  }
}
