import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/bloc/course_state.dart';

import 'package:task6_adv/models/course.dart';
part 'course_event.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    on<LoadCourseEvent>(_onLoadCourse);
  }

  Future<void> _onLoadCourse(
      LoadCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(event.courseId)
          .get();

      if (courseSnapshot.exists) {
        final courseData = Course.fromJson(
          courseSnapshot.data() as Map<String, dynamic>,
        );
        emit(CourseLoaded(course: courseData));
      } else {
        emit(const CourseError('Course not found.'));
      }
    } catch (e) {
      emit(CourseError('Failed to fetch course: $e'));
    }
  }
}
