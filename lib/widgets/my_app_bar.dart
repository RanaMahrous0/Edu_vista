import 'package:flutter/material.dart';
import 'package:task6_adv/pages/cart_page.dart';
import 'package:task6_adv/pages/home_page.dart';
import 'package:task6_adv/utility/color_utility.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Widget title;
  const MyAppBar({required this.title, required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomePage.id);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: ColorUtility.scaffoldBackground,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CartPage.id);
            },
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
