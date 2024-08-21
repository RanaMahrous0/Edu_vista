import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/categories_widget.dart';
import 'package:task6_adv/widgets/course_widget.dart';
import 'package:task6_adv/widgets/my_app_bar.dart';
import 'package:task6_adv/widgets/my_label_text.dart';
import 'package:task6_adv/widgets/my_label_widget.dart';

class HomePage extends StatefulWidget {
  static const String id = 'HomePage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<void> getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      username = capitalize(user?.displayName ?? 'User');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        height: 40,
        title: titleAppBarWidget(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyLabelWidget(onSeeAllClicked: () {}, label: 'Category'),
                const SizedBox(
                  height: 10,
                ),
                const CategoriesWidget(),
                const SizedBox(
                  height: 20,
                ),
                MyLabelWidget(
                    onSeeAllClicked: () {}, label: 'Students Alse Search For'),
                const CoursesWidget(rankValue: 'top_rated'),
                const SizedBox(
                  height: 20,
                ),
                MyLabelWidget(
                    onSeeAllClicked: () {}, label: 'Top Courses in IT'),
                const CoursesWidget(rankValue: 'top_rated'),
                const SizedBox(
                  height: 20,
                ),
                MyLabelWidget(onSeeAllClicked: () {}, label: 'Top Sellers'),
                const CoursesWidget(rankValue: 'top_seller')
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleAppBarWidget() {
    return Row(
      children: [
        const MyLabelText(fontSize: 20, text: 'Welcome'),
        const SizedBox(
          width: 4,
        ),
        MyLabelText(
          fontSize: 20,
          text: username ?? '',
          color: ColorUtility.main,
        ),
      ],
    );
  }

  String capitalize(String? s) {
    if (s == null || s.isEmpty) {
      return '';
    }
    return s[0].toUpperCase() + s.substring(1);
  }
}
