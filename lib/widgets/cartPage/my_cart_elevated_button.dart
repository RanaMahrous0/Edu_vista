import 'package:flutter/material.dart';
import 'package:task6_adv/utility/color_utility.dart';

class MyCartElevatedButton extends StatelessWidget {
  final void Function() onPressed;
  final bool isBuy;
  final String title;
  const MyCartElevatedButton(
      {required this.title,
      required this.isBuy,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        backgroundColor: isBuy ? ColorUtility.secondry : ColorUtility.whiteGray,
        foregroundColor: isBuy ? Colors.white : Colors.black,
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
            fontSize: 14,
            fontWeight: isBuy ? FontWeight.w700 : FontWeight.w500),
      ),
    );
  }
}
