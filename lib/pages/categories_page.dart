import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/blocs/category/bloc/category_bloc.dart';
import 'package:task6_adv/blocs/category/bloc/category_state.dart';
import 'package:task6_adv/blocs/coursesForCategory/bloc/course_for_category_bloc.dart';
import 'package:task6_adv/models/course.dart';
import 'package:task6_adv/pages/course_details_page.dart';
import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/app_bar_title_widget.dart';
import 'package:task6_adv/widgets/categoryPage/category_list_widget.dart';
import 'package:task6_adv/widgets/categoryPage/course_item_widget.dart';
import 'package:task6_adv/widgets/my_app_bar.dart';
import 'package:task6_adv/widgets/my_label_widget.dart';

class CategoriesPage extends StatefulWidget {
  static const String id = 'CategoriesPage';
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String? expandedCategoryId;
  List<Course> courses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: AppBarTitleWidget(title: 'Categories'),
        
        height: 40,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading && expandedCategoryId == null) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoryLoaded) {
              return ListView.builder(
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  final isExpanded = category.id == expandedCategoryId;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category item with arrow button
                      CategoryListWidget(
                        category: category,
                        onArrowTap: () {
                          setState(() {
                            expandedCategoryId = category.id;
                          });
                          context.read<CourseForCategoryBloc>().add(
                                FetchCoursesForCategory(category.id ?? ''),
                              );
                        },
                        buildCoursesRow: BlocBuilder<CourseForCategoryBloc,
                            CourseForCategoryState>(
                          builder: (context, state) {
                            if (state is CourseCategoryLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is CategoryWithCoursesLoaded &&
                                state.selectedCategory.id == category.id) {
                              courses = state.courses;
                              return _buildCoursesRow();
                            } else if (state is CategoryWithCoursesLoaded &&
                                state.selectedCategory.id == category.id &&
                                courses.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Center(
                                    child: Text(
                                        "No courses available for this category.")),
                              );
                            }
                            return Container(
                              child: Text('data'),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            } else if (state is CategoryError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No categories available.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildCoursesRow() {
    if (courses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(child: Text("No courses available for this category.")),
      );
    }
    final displayedCourses =
        courses.length > 2 ? courses.sublist(0, 2) : courses;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          MyLabelWidget(onSeeAllClicked: () {}, label: ''),
          const SizedBox(
            height: 10,
          ),
          GridView.count(
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              children: List.generate(displayedCourses.length, (index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailsPage(
                              courseId: displayedCourses[index].id ?? ''),
                        ));
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorUtility.scaffoldBackground,
                          borderRadius: BorderRadius.circular(40)),
                      child: CourseItemWidget(course: displayedCourses[index])),
                );
              })),
        ],
      ),
    );
  }
}
