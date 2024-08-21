import 'package:flutter/material.dart';

class MyLabelText extends StatelessWidget {
  final String text;
  final Color? color;
  final double fontSize;

  const MyLabelText(
      {required this.fontSize, this.color, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? const Color(0xff000000),
          fontWeight: FontWeight.w700,
          fontSize: fontSize),
    );
  }
}
