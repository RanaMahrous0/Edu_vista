import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task6_adv/pages/categories_page.dart';
import 'package:task6_adv/pages/see_all_courses_page.dart';
import 'package:task6_adv/widgets/courseDetailsPage/categories_widget.dart';
import 'package:task6_adv/widgets/homePage/course_widget.dart';
import 'package:task6_adv/widgets/homePage/viewed_course_widget.dart';
import 'package:task6_adv/widgets/my_label_widget.dart';

class HomeContentWidget extends StatelessWidget {
  const HomeContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyLabelWidget(
                onSeeAllClicked: () {
                  Navigator.pushReplacementNamed(context, CategoriesPage.id);
                },
                label: 'Category'),
            const SizedBox(
              height: 10,
            ),
            const CategoriesWidget(),
            const SizedBox(
              height: 20,
            ),
            MyLabelWidget(
                onSeeAllClicked: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SeeAllCoursesPage(
                                filiteredBy: 'Because you viewed',
                              )));
                },
                label: 'Because You Viewed'),
            const ViewedCoursesWidget(
              seeAll: false,
            ),
            const SizedBox(
              height: 20,
            ),
            MyLabelWidget(
                onSeeAllClicked: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SeeAllCoursesPage(
                                filiteredBy: 'top_rated',
                              )));
                },
                label: 'Top Courses in IT'),
            const CoursesWidget(seeAll: false, rankValue: 'top_rated'),
            const SizedBox(
              height: 20,
            ),
            MyLabelWidget(
                onSeeAllClicked: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SeeAllCoursesPage(
                                filiteredBy: 'top_seller',
                              )));
                },
                label: 'Top Sellers'),
            const CoursesWidget(seeAll: false, rankValue: 'top_seller')
          ],
        ),
      ),
    );
  }
}
