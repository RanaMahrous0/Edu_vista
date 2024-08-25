import 'package:equatable/equatable.dart';
import 'package:task6_adv/models/course.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final Course course;

  const CourseLoaded({required this.course});

  @override
  List<Object?> get props => [course];
}

class CourseError extends CourseState {
  final String message;

  const CourseError(this.message);

  @override
  List<Object?> get props => [message];
}
