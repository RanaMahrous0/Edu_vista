import 'package:flutter/material.dart';
import 'package:task6_adv/utility/color_utility.dart';

class MyTextButton extends StatelessWidget {
  final void Function()? onTap;
  final String label;
  final Color? color;
  final double? fontSize;

  const MyTextButton(
      {this.fontSize,
      this.color,
      required this.label,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          label,
          style: TextStyle(
              color: color ?? ColorUtility.secondry,
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
