part of 'course_for_category_bloc.dart';

sealed class CourseForCategoryState extends Equatable {
  const CourseForCategoryState();

  @override
  List<Object> get props => [];
}

class CourseCategoryLoading extends CourseForCategoryState {}

final class CourseForCategoryInitial extends CourseForCategoryState {}

class CategoryWithCoursesLoaded extends CourseForCategoryState {
  final CategoryData selectedCategory;
  final List<Course> courses;

  CategoryWithCoursesLoaded(this.selectedCategory, this.courses);
}

class CourseCategoryError extends CourseForCategoryState {
  final String message;

  const CourseCategoryError(this.message);
}
