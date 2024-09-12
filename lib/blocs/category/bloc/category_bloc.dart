import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/models/category_data.dart';
import 'package:task6_adv/models/course.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc(FirebaseFirestore instance) : super(CategoryLoading()) {
    // Register event handlers using on<Event>
    on<FetchCategories>(_onFetchCategories);
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Handler for fetching categories
  Future<void> _onFetchCategories(
      FetchCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading()); // Emit loading state

    try {
      // Fetch the categories from Firestore
      QuerySnapshot snapshot = await firestore.collection('category').get();
      List<CategoryData> categories = snapshot.docs.map((doc) {
        return CategoryData.fromJson(doc.data() as Map<String, dynamic>,
            doc.id); // Map Firestore data to the Category model
      }).toList();

      emit(CategoryLoaded(categories)); // Emit loaded categories state
    } catch (e) {
      emit(CategoryError("Failed to load categories: ${e.toString()}"));
    }
  }

  // Handler for fetching courses based on a category ID
}
