import 'package:task6_adv/models/category_data.dart';

abstract class CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryData> categories;

  CategoryLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}
