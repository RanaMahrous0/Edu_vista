import 'package:flutter/material.dart';
import 'package:task6_adv/utility/color_utility.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Widget title;
  const MyAppBar({required this.title, required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: ColorUtility.scaffoldBackground,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_shopping_cart),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        automaticallyImplyLeading: false,
        title: title);
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
