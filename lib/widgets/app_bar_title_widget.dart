import 'package:flutter/material.dart';

class AppBarTitleWidget extends StatelessWidget {
  final String title;
  const AppBarTitleWidget({required this.title, super.key});

  @override

  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700));
  }
}
