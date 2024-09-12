import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/blocs/lecture/bloc/lecture_event.dart';
import 'package:task6_adv/blocs/lecture/bloc/lecture_state.dart';
import 'package:task6_adv/models/lecture.dart';

class LectureBloc extends Bloc<LectureEvent, LectureState> {
  LectureBloc() : super(LectureInitial()) {
    on<LoadLecturesEvent>(_onLoadLectures);
    on<SelectLectureEvent>(_onSelectLecture);
  }

  Future<void> _onLoadLectures(
      LoadLecturesEvent event, Emitter<LectureState> emit) async {
    emit(LectureLoading());
    try {
      QuerySnapshot lecturesSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(event.courseId)
          .collection('lecture')
          .orderBy('sort')
          .get();

      List<Lecture> lectures = lecturesSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Lecture.fromJson({
          'title': data['title'],
          'description': data['description'],
          'duration': data['duration'],
          'lectureUrl': data['lectureUrl'],
        });
      }).toList();

      emit(LectureLoaded(lectures: lectures));
    } catch (e) {
      emit(LectureError('Failed to fetch lectures: $e'));
    }
  }

  void _onSelectLecture(SelectLectureEvent event, Emitter<LectureState> emit) {
    emit(LectureSelected(lecture: event.lecture));
  }
}
