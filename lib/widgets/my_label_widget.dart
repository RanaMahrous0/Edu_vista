import 'package:flutter/material.dart';
import 'package:task6_adv/widgets/myTextButton.dart';
import 'package:task6_adv/widgets/my_label_text.dart';

class MyLabelWidget extends StatelessWidget {
  final String label;
  final void Function() onSeeAllClicked;

  const MyLabelWidget(
      {required this.onSeeAllClicked, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyLabelText(fontSize: 18, text: label),
        MyTextButton(
            fontSize: 17,
            color: const Color(0xff000000),
            label: 'See All',
            onTap: onSeeAllClicked)
      ],
    );
  }
}
