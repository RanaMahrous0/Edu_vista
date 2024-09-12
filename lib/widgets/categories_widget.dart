import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task6_adv/models/category_data.dart';
import 'package:task6_adv/widgets/my_chip_widget.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  var categoryDocs = FirebaseFirestore.instance.collection('category').get();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: FutureBuilder(
        future: categoryDocs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error in Loading Categories ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
            return const Center(
              child: Text('No Categories Found'),
            );
          }
          var categories = List<CategoryData>.from(snapshot.data?.docs
                  .map(
                    (e) =>
                        CategoryData.fromJson({'id': e.id, ...e.data()}, null),
                  )
                  .toList() ??
              []);

          return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
              itemBuilder: (context, index) =>
                  MyChipWidget(label: Text(categories[index].name ?? '')));
        },
      ),
    );
  }
}
