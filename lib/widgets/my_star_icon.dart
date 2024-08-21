import 'package:flutter/material.dart';
import 'package:task6_adv/utility/color_utility.dart';

class MyStarIcon extends StatelessWidget {
  final IconData iconData;
  const MyStarIcon({required this.iconData, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(iconData, color: ColorUtility.main, size: 16);
  }
}
