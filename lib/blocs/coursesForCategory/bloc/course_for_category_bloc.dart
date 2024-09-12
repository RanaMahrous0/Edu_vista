import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/models/category_data.dart';
import 'package:task6_adv/models/course.dart';

part 'course_for_category_event.dart';
part 'course_for_category_state.dart';

class CourseForCategoryBloc
    extends Bloc<CourseForCategoryEvent, CourseForCategoryState> {
  CourseForCategoryBloc() : super(CourseForCategoryInitial()) {
    on<FetchCoursesForCategory>(_onFetchCoursesForCategory);
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> _onFetchCoursesForCategory(FetchCoursesForCategory event,
      Emitter<CourseForCategoryState> emit) async {
    emit(CourseCategoryLoading()); 

    final categoryId = event.categoryId; 

 
    if (categoryId.isEmpty) {
      emit(const CourseCategoryError("Invalid category ID"));
      return;
    }

    try {
    
      print("Fetching courses for categoryId: ${event.categoryId}");

      QuerySnapshot snapshot = await firestore
          .collection('courses')
          .where('categoryId',
              isEqualTo: categoryId) 
          .get();


      if (snapshot.docs.isEmpty) {
        print("No courses found for this category");
      }

 
      print("Number of courses fetched: ${snapshot.docs.length}");

      List<Course> courses = snapshot.docs.map((doc) {
        return Course.fromJson(doc.data()
            as Map<String, dynamic>); 
      }).toList();

      DocumentSnapshot categoryDoc =
          await firestore.collection('category').doc(categoryId).get();

      if (!categoryDoc.exists) {
        emit(const CourseCategoryError("Category not found"));
        return;
      }

      CategoryData selectedCategory = CategoryData.fromJson(
          categoryDoc.data() as Map<String, dynamic>, categoryDoc.id);

      print("Category fetched successfully: ${selectedCategory.name}");

      emit(CategoryWithCoursesLoaded(
          selectedCategory, courses)); 
    } catch (e) {
      emit(CourseCategoryError("Failed to load courses: ${e.toString()}"));
    }
  }
}
