import 'package:flutter/material.dart';
import 'package:task6_adv/models/category_data.dart';
import 'package:task6_adv/models/course.dart';

import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/categoryPage/course_item_widget.dart';

class CategoryListWidget extends StatefulWidget {
  final CategoryData category;
  final Widget buildCoursesRow;

  final VoidCallback onArrowTap;

  const CategoryListWidget(
      {super.key,
      required this.buildCoursesRow,
      required this.category,
      required this.onArrowTap});

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: isExpanded
                  ? ColorUtility.scaffoldBackground
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: isExpanded ? ColorUtility.secondry : Colors.transparent,
                width: 2.0,
              ),
            ),
            child: ListTile(
                title: Text(
                  widget.category.name ?? 'No Name',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: isExpanded ? ColorUtility.secondry : Colors.black,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                    widget.onArrowTap();
                  },
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_double_arrow_down
                        : Icons.keyboard_double_arrow_right,
                    color: isExpanded ? ColorUtility.secondry : Colors.black,
                  ),
                )),
          ),
        ),
        isExpanded ? widget.buildCoursesRow : Container(),
      ],
    );
  }
}
