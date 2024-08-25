import 'package:equatable/equatable.dart';

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
