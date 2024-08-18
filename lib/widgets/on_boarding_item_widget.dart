import 'package:flutter/material.dart';
import 'package:task6_adv/utility/color_utility.dart';

class OnBoardingItemWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;

  const OnBoardingItemWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 300, height: 300, child: Image.asset(image)),
          const SizedBox(
            height: 30,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            subTitle,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: ColorUtility.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
