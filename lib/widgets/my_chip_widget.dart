import 'package:flutter/material.dart';

class MyChipWidget extends StatelessWidget {
  final Widget label;
  const MyChipWidget({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: label,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      backgroundColor: const Color(0xffE0E0E0),
    );
  }
}
