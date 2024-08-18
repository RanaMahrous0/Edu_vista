import 'package:flutter/material.dart';
import 'package:task6_adv/utility/color_utility.dart';

class MyTextButton extends StatelessWidget {
  final void Function()? onTap;
  final String label;
  const MyTextButton({required this.label, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          label,
          style: const TextStyle(color: ColorUtility.secondry, fontSize: 14),
        ),
      ),
    );
  }
}
