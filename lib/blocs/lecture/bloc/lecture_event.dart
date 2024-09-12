import 'package:equatable/equatable.dart';
import 'package:task6_adv/models/lecture.dart';

abstract class LectureEvent extends Equatable {
  const LectureEvent();

  @override
  List<Object?> get props => [];
}

class LoadLecturesEvent extends LectureEvent {
  final String courseId;

  const LoadLecturesEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}
class SelectLectureEvent extends LectureEvent {
  final Lecture lecture;

  const SelectLectureEvent(this.lecture);
}