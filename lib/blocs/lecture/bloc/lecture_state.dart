import 'package:equatable/equatable.dart';
import 'package:task6_adv/models/lecture.dart';

abstract class LectureState extends Equatable {
  const LectureState();

  @override
  List<Object?> get props => [];
}

class LectureInitial extends LectureState {}

class LectureLoading extends LectureState {}

class LectureLoaded extends LectureState {
  final List<Lecture> lectures;

  const LectureLoaded({required this.lectures});

  @override
  List<Object?> get props => [lectures];
}

class LectureError extends LectureState {
  final String message;

  const LectureError(this.message);

  @override
  List<Object?> get props => [message];
}
