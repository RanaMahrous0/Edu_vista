part of 'course_for_category_bloc.dart';

sealed class CourseForCategoryEvent extends Equatable {
  const CourseForCategoryEvent();

  @override
  List<Object> get props => [];
}

class FetchCoursesForCategory extends CourseForCategoryEvent {
  final String categoryId;

  const FetchCoursesForCategory(this.categoryId);
}
