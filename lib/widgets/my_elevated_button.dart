import 'package:flutter/material.dart';

import 'package:task6_adv/utility/color_utility.dart';

class MyElevatedButton extends StatelessWidget {
  final void Function() onPressed;
  final double? horizontal;
  final Widget? child;
  final double? width;
  final Color? backgroundColor;
  final Color? foregroundColor;

  final String? text;

  const MyElevatedButton(
      {required this.onPressed,
      this.backgroundColor,
      this.foregroundColor,
      this.width,
      this.horizontal,
      this.child,
      this.text,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: horizontal ?? 20),
      child: SizedBox(
          width: width ?? double.infinity,
          height: 50,
          child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: ColorUtility.grayLight),
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: backgroundColor ?? ColorUtility.secondry,
                  foregroundColor: foregroundColor ?? Colors.white,
                  surfaceTintColor: Colors.white),
              child: text != null
                  ? Text(
                      text!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    )
                  : child)),
    );
  }
}
