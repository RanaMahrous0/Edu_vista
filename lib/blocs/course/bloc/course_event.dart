part of 'course_bloc.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

class LoadCourseEvent extends CourseEvent {
  final String courseId;

  const LoadCourseEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}
