import 'package:flutter/material.dart';
import 'package:task6_adv/widgets/categories_widget.dart';
import 'package:task6_adv/widgets/my_label_text.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyLabelText(
            fontSize: 18,
            text: 'Trending',
          ),
          SizedBox(
            height: 10,
          ),
          CategoriesWidget(),
          SizedBox(
            height: 18,
          ),
          MyLabelText(fontSize: 18, text: 'Based on your search'),
          SizedBox(
            height: 10,
          ),
          CategoriesWidget(),
        ],
      ),
    );
  }
}
